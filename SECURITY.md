# Security Policy

> [!IMPORTANT]
> **Our bounty program is on pause until further notice.** We may exceptionally reward reports at our own discretion, mostly for critical issues (see [What we care about most](#what-we-care-about-most)), but you should not expect or ask for a reward.
>
> We still welcome responsible disclosure of any vulnerability, and our safe harbor commitment below still applies.

## Safe harbor

We will not take legal action against you or ask law enforcement to investigate you, as long as you follow this policy and make a good faith effort to avoid privacy violations, destruction of data, and interruption or degradation of our services.

## Rules

- Test locally or on staging, never on production (see [Scope](#scope)).
- Don't use automated scanners or tools that could degrade our services.
- Don't access, leak, modify, or destroy data that doesn't belong to you.
- Report within 72 hours of discovery, and wait for the fix before disclosing publicly.
- Send at most 2 reports per week. Send the most severe first.
- If you use AI, review the report yourself and make sure it's correct before sending it. Reporters who repeatedly send unverified reports will be ignored.

## What we care about most

We read every report, but we look at these first:

- Authentication bypass or account takeover
- Access to, or control over, payment methods or connected accounts (Stripe, PayPal, Wise, etc.)
- Moving funds, or breaking the integrity of our transactions ledger
- Privilege escalation or bypasses of our permission system (e.g. acting as an admin of an account you don't own)
- Remote code execution, SQL injection, SSRF
- Stored XSS on a page other users visit

If you think you've found one of these, say so clearly in the email subject (see [How to report](#how-to-report)).

## How to report

Email **security@opencollective.com**, in English, with:

- **Subject:** `[Security] <service>: <one-line impact>`, for example `[Security] API: any user can approve expenses of other collectives`.
- **Body** (not as a PDF attachment, which may be ignored):
  - A short summary: what an attacker can do, and what they need first (an account? admin of a collective?).
  - Steps to reproduce on a local or staging environment, with a proof of concept.
  - This sentence: _I have read and accepted the Security Policy of Open Collective._

Reports that don't follow this format may be ignored. You can send a short summary first, without a full proof of concept, to check whether we already know about the issue.

We'll confirm we received your report and get back to you if we need more details. Once the issue is fixed, we may ask you to check the fix. You can go public after we confirm the fix is released.

## Scope

All testing must be done locally or on staging. We **won't** accept reports made by testing on production (https://opencollective.com).

| Service  | Source code                                                                          | Staging                                   |
| -------- | ------------------------------------------------------------------------------------ | ----------------------------------------- |
| API      | [opencollective-api](https://github.com/opencollective/opencollective-api)           | https://api-staging.opencollective.com    |
| Frontend | [opencollective-frontend](https://github.com/opencollective/opencollective-frontend) | https://staging.opencollective.com        |
| PDF      | [opencollective-pdf](https://github.com/opencollective/opencollective-pdf)           | https://pdf-staging.opencollective.com    |
| REST     | [opencollective-rest](https://github.com/opencollective/opencollective-rest)         | https://rest-staging.opencollective.com   |
| Images   | [opencollective-images](https://github.com/opencollective/opencollective-images)     | https://images-staging.opencollective.com |

Out of scope:

- **Private organizations**: still being tested internally.
- **OpenSearch**: only available to privileged users for now.
- **GraphQL V1** (`/graphql/v1`) missing OAuth or personal token scope checks: token-based clients can't use it by default.

## Not considered vulnerabilities

We won't act on reports about:

- Self-XSS, text/HTML injection, homograph attacks, RTLO characters
- Clickjacking, missing security headers or cookie flags, autocomplete attributes, mixed content, SSL/TLS best practices
- Missing or invalid SPF/DKIM/DMARC records
- Rate limiting and denial of service
- Low-impact CSRF (e.g. logout)
- Information disclosure without security impact, such as software versions, stack traces, or paths
- Single-session features and session management
- Social engineering, or attacks requiring physical access to a device
- Outdated browsers or platforms, and recently disclosed 0-days
- File extension manipulation without evidence of a vulnerability
- Public GraphQL introspection and permissive API CORS (both intentional)
- Theoretical issues or best practices without a working proof of concept, including unvalidated scanner output
