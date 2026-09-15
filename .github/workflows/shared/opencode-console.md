---
engine:
  id: opencode
  version: "1.18.30"
  display-name: OpenCode Console
  description: OpenCode CLI against OpenCode Console (pay-as-you-go) using OPENCODE_API_KEY
  runtime-id: opencode
  experimental: true
  provider:
    name: opencode
  auth:
    - role: api-key
      secret: OPENCODE_API_KEY
  behaviors:
    supported-env-var-keys:
      - OPENCODE_API_KEY
    capabilities:
      max-turns: true
      tools-allowlist: true
    manifest:
      files:
        - opencode.jsonc
        - AGENTS.md
      path-prefixes:
        - .opencode/
    network:
      defaults:
        - host.docker.internal
        - github.com
        - raw.githubusercontent.com
        - opencode.ai
        - models.dev
      provider-domains:
        opencode: opencode.ai
        anthropic: api.anthropic.com
        openai: api.openai.com
        google: generativelanguage.googleapis.com
        groq: api.groq.com
        mistral: api.mistral.ai
        deepseek: api.deepseek.com
        xai: api.x.ai
    installation:
      package-manager: npm
      package-name: opencode-ai
      version: "1.18.30"
      step-name: Install OpenCode CLI
      binary-name: opencode
      include-node-setup: true
      # OpenCode 1.15+ ships a stub bin; postinstall selects the platform binary.
      # gh-aw defaults to npm --ignore-scripts, which leaves `opencode --version` broken.
      post-install-scripts: true
      cooldown: true
      verify-command: opencode --version
      verify-step-name: Verify OpenCode CLI installation
      docs-url: https://opencode.ai/docs
    config-file:
      path: opencode.jsonc
      step-name: Write OpenCode Config
      content: |-
        {
          "agent": {
            "build": {
              "permission": {
                "bash": "allow",
                "edit": "allow",
                "read": "allow",
                "glob": "allow",
                "grep": "allow",
                "webfetch": "allow",
                "websearch": "allow",
                "external_directory": "allow"
              }
            }
          },
          "autoupdate": false,
          "pluginAutoInstall": false
        }
      merge-strategy: json-merge
    execution:
      command-name: opencode
      args:
        - run
        - --print-logs
        - --log-level
        - DEBUG
      step-name: Execute OpenCode CLI
      model-env-var: OPENCODE_MODEL
      mcp-config-env-var: GH_AW_MCP_CONFIG
      write-timestamp: true
      env:
        # Config/data must live under /tmp/gh-aw so AWF's RW mount sees the preseeded plugin SDK.
        XDG_CONFIG_HOME: /tmp/gh-aw/opencode-config
        XDG_DATA_HOME: /tmp/gh-aw/opencode-data
        OPENCODE_PURE: "1"
        OPENCODE_DISABLE_AUTOUPDATE: "1"
        OPENCODE_DISABLE_DEFAULT_PLUGINS: "1"
        OPENCODE_DISABLE_LSP_DOWNLOAD: "1"
    mcp:
      config-path: opencode.jsonc
    log-parser: |
      function parseLog(logContent) {
        const lines = logContent.split("\n");
        const logEntries = [];
        const mcpFailures = [];
        let maxTurnsHit = false;
        const AWF_INFRA_RE = /^\[(INFO|WARN|SUCCESS|ERROR|entrypoint|health-check)\]|^ (?:Container|Network|Volume) |^Process exiting with code:/;
        let inputTokens = 0;
        let outputTokens = 0;
        let toolCallIndex = 0;
        let turnCount = 0;
        let pendingText = [];

        function flushText() {
          if (pendingText.length === 0) return;
          const text = pendingText.join("\n").trim();
          if (text) {
            logEntries.push({ type: "assistant", message: { content: [{ type: "text", text }] } });
            turnCount++;
          }
          pendingText = [];
        }

        logEntries.push({ type: "system", subtype: "init", model: null, session_id: null });

        for (const line of lines) {
          if (!line.trim()) continue;
          if (AWF_INFRA_RE.test(line)) continue;
          if (/max.?turns|maximum.*turns.*reached|turn limit/i.test(line)) maxTurnsHit = true;
          if (/MCP server .* failed|MCP.*connection.*error|Failed to connect to MCP/i.test(line)) {
            const serverMatch = line.match(/MCP server ['"]?([^\s'"]+)['"]?/i);
            mcpFailures.push(serverMatch ? serverMatch[1] : line.trim());
          }

          let parsed = null;
          try {
            if (line.trim().startsWith("{")) parsed = JSON.parse(line.trim());
          } catch (e) { /* not JSON */ }

          if (parsed) {
            const entryType = parsed.type != null ? String(parsed.type) : "log";
            const msg = parsed.msg || parsed.message || "";
            if (parsed.input_tokens) inputTokens += parsed.input_tokens;
            if (parsed.output_tokens) outputTokens += parsed.output_tokens;

            if (/tool[._]call|tool[._]use/i.test(entryType)) {
              flushText();
              const toolId = `opencode_tool_${toolCallIndex++}`;
              const toolName = parsed.tool || parsed.name || entryType;
              logEntries.push({ type: "assistant", message: { content: [{ type: "tool_use", id: toolId, name: toolName, input: {} }] } });
              logEntries.push({ type: "user", message: { content: [{ type: "tool_result", tool_use_id: toolId, content: msg }] } });
            } else if (msg) {
              pendingText.push(msg);
            }
          } else {
            pendingText.push(line.trim());
          }
        }
        flushText();

        const usage = {};
        if (inputTokens) usage.input_tokens = inputTokens;
        if (outputTokens) usage.output_tokens = outputTokens;
        logEntries.push({ type: "result", num_turns: turnCount, usage });
        const parts = [`**Turns:** ${turnCount}`, `**Tool calls:** ${toolCallIndex}`];
        if (inputTokens || outputTokens) parts.push(`**Tokens:** ${((inputTokens ?? 0) + (outputTokens ?? 0)).toLocaleString()}`);
        if (mcpFailures.length) parts.push(`**MCP failures:** ${mcpFailures.length}`);
        if (maxTurnsHit) parts.push("**Max turns reached**");
        return { markdown: parts.join(" · "), logEntries, mcpFailures, maxTurnsHit };
      }
pre-agent-steps:
  - name: Preinstall OpenCode plugin SDK
    run: |
      set -euo pipefail
      version="${GH_AW_ENGINE_VERSION:?GH_AW_ENGINE_VERSION is required}"
      preseed() {
        local dir="$1"
        mkdir -p "$dir"
        (cd "$dir" && npm install --ignore-scripts --no-fund --no-audit "@opencode-ai/plugin@${version}")
        test -d "$dir/node_modules/@opencode-ai/plugin"
        test -f "$dir/package-lock.json"
      }
      # Host network is open here. OpenCode arborist-installs this package into
      # every config dir it scans; without node_modules + lockfile it hits
      # registry.npmjs.org inside AWF and 403s / hangs waitForDependencies.
      preseed "/tmp/gh-aw/opencode-config/opencode"
      preseed "${GITHUB_WORKSPACE}/.opencode"
      preseed "${HOME}/.config/opencode"
---

<!--
Vendored OpenCode engine for OpenCode Console (pay-as-you-go).

Do not replace this with github/gh-aw's sample shared/opencode.md. That sample
disables the `opencode` provider and rewrites models through awf-proxy / Copilot.
Muse Spark is Responses-API-only and must keep the built-in `opencode` provider
so the CLI calls https://opencode.ai/zen/v1/responses with OPENCODE_API_KEY.

Import this file and set:

```yaml
imports:
  - shared/opencode-console.md
engine:
  id: opencode
  model: opencode/muse-spark-1.3-contributor-free
```

`OPENCODE_API_KEY` is injected from the repository secret of the same name via `engine.auth`.

`behaviors.installation.post-install-scripts` must stay true. From 1.15, `opencode-ai`
replaces its npm stub with a native binary in postinstall; gh-aw otherwise compiles
`npm install --ignore-scripts -g opencode-ai@…` and verify fails with
"opencode-ai's postinstall script was not run."

Do not add the `node` ecosystem to `network.allowed` just to unblock startup. OpenCode
always arborist-installs `@opencode-ai/plugin` into `$XDG_CONFIG_HOME/opencode` and
`waitForDependencies` can hang when AWF returns 403 for registry.npmjs.org. Preinstall
that SDK on the host (pre-agent-steps) and keep `OPENCODE_PURE=1`.
-->
