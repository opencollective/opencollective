# RFC 017 - GraphQL access control via `defineProtectedField`

## Affected projects

- API (primary)
- graphql-docs-v2 (documentation generation)

## Motivation

GraphQL resolvers in opencollective-api must declare who may call them: session vs OAuth vs personal token, whether login is required, and which OAuth scopes apply. Today that intent is easy to miss.

\*\*We're partially protected by the ESLint rule `graphql-mutations/require-scope-check`, which rejects any mutation resolver that does not call a function from `server/graphql/common/scope-check.ts`, but this lacks standardization and false negatives are possible. There is no equivalent for queries. A resolver can ship without any scope or auth check, and nothing in CI will fail.

We want a pattern that:

1. **Forces implementers to think about access control** - scopes and authentication cannot be an afterthought; they are the first arguments when defining a field.
2. **Makes omissions structurally difficult** - combined with ESLint, it should not be possible to add a query without explicitly declaring its access requirements (or documenting why none apply).
3. **Reduces verbosity** - no repeated `enforceScope` / `checkRemoteUserCanUse*` boilerplate at the top of every resolver.
4. **Surfaces permissions in the schema** - so generated API documentation reflects what callers need.

This is basically the experiment proposed in [opencollective#5579](https://github.com/opencollective/opencollective/issues/5579): use GraphQL directives and a small helper so permissions are declared once, enforced automatically, and visible in the exported schema.

### Evaluation criteria

| Criterion          | Target                                                      |
| ------------------ | ----------------------------------------------------------- |
| Full coverage      | Every query and mutation field must be explicitly protected |
| Safety             | Hard to forget scope/auth; lint catches bare resolvers      |
| Less verbose       | Access block replaces manual checks in `resolve`            |
| Easy to understand | One helper, explicit required fields                        |

## Solution

### `defineProtectedField`

All new and migrated top-level query fields (and, long term, mutations) should be defined through a single helper: `defineProtectedField` in `server/graphql/common/define-protected-field.ts`.

```typescript
const TransactionQuery = defineProtectedField(
  'transaction',
  {
    scopes: ['transactions'],
    requiresAuthentication: false,
    // forbidOAuth: false,           // optional, default false
    // forbidPersonalTokens: false,  // optional, default false
  },
  {
    type: GraphQLTransaction,
    description: 'Fetch a single transaction',
    args: { ... },
    async resolve(_, args, req) {
      // business logic only - no manual enforceScope here
    },
  },
);
```

**Required access parameters** (passed as one object so names are explicit):

| Parameter                | Meaning                                                                                                                                                  |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `scopes`                 | OAuth/personal token scopes required when those auth methods are used. Session/cookie auth is unaffected (`enforceScope` is a no-op without a token).    |
| `requiresAuthentication` | If `true`, unauthenticated callers get `Unauthorized`. If `false`, guests may call the field (subject to other checks, e.g. private account visibility). |

**Optional parameters** (default `false`):

| Parameter              | Meaning                                       |
| ---------------------- | --------------------------------------------- |
| `forbidOAuth`          | Reject OAuth user tokens (`req.userToken`).   |
| `forbidPersonalTokens` | Reject personal tokens (`req.personalToken`). |

These two wwill be especially useful for preventing the use of OAuth tokens to manage other OAuth apps or personal tokens, for example.

The helper:

- Wraps `resolve` and runs checks in order: token forbids → authentication → scopes.
- Stores the resolved config on `extensions.accessControl` for tooling.
- Attaches `@requiresOAuthScope(scopes: [...])` on the field AST when scopes are non-empty.

### `@requiresOAuthScope` directive

A schema directive is registered on the V2 schema:

```graphql
directive @requiresOAuthScope(scopes: [String!]!) on FIELD_DEFINITION
```

It documents OAuth scope requirements on the field. Runtime enforcement lives in the helper, not in directive visitor magic, so behavior stays obvious and testable.

Follow-up: extend the directive (or add companions) so `requiresAuthentication`, `forbidOAuth`, and `forbidPersonalTokens` also appear in SDL for documentation. The POC only exports scopes on the directive; the full access config is in `extensions.accessControl`.

### ESLint enforcement (required follow-up)

The POC is incomplete without lint rules that make bare field definitions a CI failure.

**Queries** - new rule, e.g. `graphql-queries/require-protected-field`:

- Every resolver under `server/graphql/v2/query/**` must be defined via `defineProtectedField` (or a shared wrapper that uses it).
- Opt-out with an explanatory `eslint-disable` comment for genuinely public fields (same pattern as mutations today).

**Mutations** - evolve `graphql-mutations/require-scope-check`:

- Prefer requiring `defineProtectedField` instead of only detecting a manual `enforceScope` call inside `resolve`.
- During transition, accept either the helper or an explicit scope-check call; end state should be helper-only for consistency.

Together, these rules ensure **you cannot add a query without consciously choosing** `scopes`, `requiresAuthentication`, and optional token restrictions.

### Documentation generation

Our public GraphQL docs are built with [magidoc](https://github.com/opencollective/graphql-docs-v2) from the V2 schema. When field-level directives are present in SDL, magidoc can render them on each operation ([magidoc#91](https://github.com/magidoc-org/magidoc/issues/91)).

Benefits:

- OAuth app developers see required scopes on `transaction`, `expenses`, etc. without reading resolver source.
- Internal reviewers can audit permissions from the docs site.
- Permission metadata stays DRY: same declaration drives runtime, schema, and docs.

**Caveat:** `graphql-js` `printSchema` does not yet emit custom field directives into `schemaV2.graphql` (only `@deprecated`). Follow-up work: enhance schema export or point magidoc at SDL that includes field directives from `astNode`. The directive definition and `extensions.accessControl` are already in place for that pipeline.

## Alternatives

### Status quo: manual checks in every resolver

```typescript
async resolve(_, args, req) {
  enforceScope(req, 'transactions');
  // ...
}
```

- **Pros:** No new abstraction; already used everywhere.
- **Cons:** Easy to forget on queries; no schema metadata; duplicated patterns (`enforceScope` vs `checkRemoteUserCanUse*` vs `rejectOAuthAndPersonalTokenAuth`); docs drift from code.

### ESLint only (extend mutation rule to queries)

Detect `enforceScope` calls in query resolvers without a helper.

- **Pros:** Minimal code change.
- **Cons:** Does not force structured declaration of `requiresAuthentication` or token forbids; no documentation in schema; still verbose.

### Directive visitors only (no helper)

Implement `@requiresOAuthScope` as a GraphQL directive with a schema transformer / Apollo plugin.

- **Pros:** Feels more "GraphQL-native."
- **Cons:** Harder to discover and debug; our codebase is code-first with plain field configs; visitors do not run unless clients send directives in queries unless we wrap at build time anyway.

### Multiple small directives

e.g. `@mustBeLoggedIn`, `@forbidOAuth`, `@requiresOAuthScope`.

- **Pros:** Composable in SDL.
- **Cons:** More boilerplate per field; easier to apply an incomplete set; POC consolidates into one helper with one access object.

**Chosen approach:** helper + directive metadata + ESLint. Declaration is mandatory and typed; enforcement is centralized; schema carries docs.

## Proof of concept

- Issue: [opencollective#5579](https://github.com/opencollective/opencollective/issues/5579) - Experiment with GraphQL directives for auth
- PR: [opencollective-api#11830](https://github.com/opencollective/opencollective-api/pull/11830) - `defineProtectedField` on `transaction` query only

POC includes:

- `RequiresOAuthScopeDirective` and schema registration
- `defineProtectedField` with `scopes`, `requiresAuthentication`, `forbidOAuth`, `forbidPersonalTokens`
- Migration of `TransactionQuery`
- Tests for runtime enforcement, directive registration, and access metadata

POC explicitly does **not** include:

- ESLint rules for queries (or mutation migration to the helper)
- Rollout to other queries, collections, or nested type fields
- Full SDL export of all access fields on each resolver
- magidoc / graphql-docs-v2 config update

## Adoption / Transition strategy

### Phase 1 - Land infrastructure (POC + review)

- Merge helper, directive, and one migrated field after team feedback on API shape and naming.
- Document the helper in AGENTS.md (GraphQL security checklist).

### Phase 2 - Lint gates

- Add `graphql-queries/require-protected-field`.
- Update mutation rule to accept `defineProtectedField`; plan deprecation of raw `enforceScope` in mutation bodies.

### Phase 3 - Incremental migration

Priority order:

1. Sensitive read paths (transactions, orders, expenses collections and single-object queries).
2. Mutations already covered by scope-check (swap manual calls for helper).
3. Nested resolvers that expose permission-sensitive data (`permissions.*`, receipt/tax fields).

No big-bang migration. Existing manual checks keep working until a field is touched or explicitly migrated.

### Phase 4 - Documentation pipeline

- Fix schema export so field directives appear in `schemaV2.graphql`.
- Update [graphql-docs-v2](https://github.com/opencollective/graphql-docs-v2) to use SDL introspection and display `@requiresOAuthScope` (and future access directives).
- Add a short page describing OAuth scopes and how to read the generated permission annotations.

### Teaching contributors

- New query/mutation fields: start from `defineProtectedField`; fill in the access object before writing `resolve`.
- If a field is truly public: `scopes: []`, `requiresAuthentication: false`, with a lint opt-out comment explaining why.
- Code review checklist: "Access block present? Matches product intent for tokens and guests?"

### Out of scope for this RFC

- Role-based checks (collective admin, host, root) - still imperative inside `resolve` or separate helpers; OAuth scopes are orthogonal.
- Conditional scope by argument shape - still needs custom logic.
- GraphQL V1 - V2 only.

## Summary

`defineProtectedField` makes access control a deliberate, visible step when defining GraphQL fields. Combined with ESLint and schema directives, it addresses the main weakness in our current model: **queries can ship without anyone having stated their scope or auth requirements.** The same declarations can feed automatically generated documentation so permissions stay accurate and discoverable for OAuth integrators and our own team.
