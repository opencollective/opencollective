# Security Policy

> [!WARNING]
> Due to the increase in security reports due to generative AI, we're making the following changes to our bounty policy:
> - We're only accepting up to 2 reports per individual per week. Choose carefully!
> - We're no longer offering bounties for low and, in some cases, medium severity issues. See the updated "Rewards" section.

We believe that no technology is perfect and that working with skilled security researchers
is crucial in identifying weaknesses.

If you believe you've found a security bug in our service, we'll be happy to work with you
to resolve the issue promptly and ensure you are fairly rewarded for your discovery.

We will investigate legitimate reports and make every effort to quickly resolve any vulnerability.
To encourage responsible reporting, we will not take legal action against you nor ask law enforcement
to investigate you, provided you comply with the current policy and, more generally, with the following guideline: Make a good faith effort to
avoid privacy violations, destruction of data, and interruption or degradation of our services.

## Eligibility and Responsible Disclosure

Only those who meet the following eligibility requirements may receive a monetary reward:

- You must be the first reporter of a vulnerability.
- The vulnerability must be a qualifying vulnerability.
- Any vulnerability found must be reported no later than 72 hours after discovery.
- You must send a clear textual description of the report along with steps to reproduce the issue, including attachments such as screenshots or proof of concept code as necessary.
- You must avoid tests that could cause degradation or interruption of our service (refrain from using automated tools, and limit yourself about requests per second).
- You must not leak, manipulate, or destroy any user data.
- You must not be a former or current employee of Open Collective or one of its contractors.
- You must wait for the issue to be fully fixed before exposing it publicly.
- There must be proof that, given realistic processing power and time, an exploit is possible.
- When using AI, you must manually review that the report you're submitting is correct. Repeated offense of this rule will lock you out of our bounty program.
- Each reporter can only submit up to 3 reports a week. Make sure to report the most severe vulnerabilities first.

## Scope

We **won't** accept reports made by testing on our production servers (https://opencollective.com).

You must ideally do all the testing locally. See the following links:

- API: https://github.com/opencollective/opencollective-api
- Frontend: https://github.com/opencollective/opencollective-frontend
- PDF: https://github.com/opencollective/opencollective-pdf
- Rest: https://github.com/opencollective/opencollective-rest
- Images: https://github.com/opencollective/opencollective-images

In case you really need to test on a live environment, we provide staging servers on the following URLs:

- API: https://api-staging.opencollective.com
- Frontend: https://staging.opencollective.com
- PDF: https://pdf-staging.opencollective.com
- Rest: https://rest-staging.opencollective.com
- Images: https://images-staging.opencollective.com

### Out-of-scope features

- Private organizations: currently being tested internally, we will not offer bounties until the feature is fully released and tested on our side.
- OpenSearch: only available to priviledged users for now.

## Contact

- Mail: security@opencollective.com
- Preferred languages: English
- Your report must be included in the email body. PDFs attachments may be ignored by the team.
- You MUST include the following sentence in your message:

> I have read and accepted the Security Policy of Open Collective.

Non-compliant reports will be ignored.

## Rewards

| Project     | Type            | Security requirement | Low   | Medium | High  | Critical |
| ----------- | --------------- | -------------------- | ----- | ------ | ----- | -------- |
| API         | API             | +++                  | \$0  | \$100   | \$600 | \$1200   |
| Frontend    | Web Application | +++                  | \$0  | \$100   | \$600 | \$1200   |
| PDF service | API             | ++                   | \$0  | \$0     | \$300 | \$600    |
| Images      | API             | ++                   | \$0  | \$0     | \$300 | \$600    |
| REST        | API             | ++                   | \$0  | \$0     | \$300 | \$600    |

Issues that we categorize as "Minimal" severity are not elligible for bounties. 

Note: we are not able to pay bounties to people based in countries sanctioned by the United States, or countries where US sanctions are so widespread that our payment processors no longer serve them.

## Qualifying vulnerabilities

- Remote code execution (RCE)
- Local files access and manipulation (LFI, RFI, XXE, SSRF, XSPA)
- Code injections (JS, SQL, PHP, ...)
- Cross-Site Scripting (XSS)
- Cross-Site Requests Forgery (CSRF) with real security impact
- Open redirect
- Broken authentication & session management
- Insecure direct object references
- CORS with real security impact
- Horizontal and vertical privilege escalation
- SQL injections

## Non-qualifying vulnerabilities

- "Self" XSS
- Rate Limiting
- Text/HTML Injection
- Social engineering
- Homograph Attack
- Missing cookie flags
- Information disclosure
- SSL/TLS best practices
- Mixed content warnings
- Denial of Service attacks
- Missing security headers
- Clickjacking/UI redressing
- Software version disclosure
- Stack traces or path disclosure
- Missing autocomplete attributes
- Physical or social engineering attempts
- Recently disclosed 0-day vulnerabilities
- Presence of autocomplete attribute on web forms
- Vulnerabilities affecting outdated browsers or platforms
- Our policies on presence/absence of SPF/DMARC records
- Any hypothetical flaw or best practices without exploitable POC
- Issues that require physical access to a victim’s computer/device
- Logout and other instances of low-severity Cross-Site Request Forgery
- Extension manipulation without any evidence of vulnerability (Attachments)
- Missing security-related HTTP headers which do not lead directly to a vulnerability
- Reports from automated web vulnerability scanners (Acunetix, Vega, etc.) that have not been validated
- Invalid or missing SPF (Sender Policy Framework) records (Incomplete or missing SPF/DKIM/DMARC)
- Any issues regarding single session features/management
- RTLO and related issues
- Missing OAuth or personal token scope checks on **GraphQL V1** (`/graphql/v1`): token-based clients are not allowed to use it by default.

## Process

- Reporter submit a report. To make sure that you don't loose too much time preparing a nice report if the issue is already known from us, you can submit just a small summary without technical details and proofs of concepts.
- Open Collective Team...
  - Confirms that the report has been received. If it's an unknown issue, we may ask you for more details.
  - Tries to confirm/reproduce the issue.
  - Discuss results and possible impact to determine the score (low/medium/high/critical) and bounty amount.
- Reporter is rewarded with a bounty at this stage (if applicable).
- Team works on a fix, verifies it an pushes it.
- Team confirms that the issue has been patched and may ask reporter to check the fix.
- We write a postmortem to document the issue. From this point it is safe for reporter to go public about the issue.

## How do we calculate the severity score

Our analysis is always based on worst case exploitation of the vulnerability, as is the reward we pay. We will rely on CVSS3 as well as internal criteria to score the vulnerabilities.

Things that we take into account to adjust the score for vulnerabilities:

- Everything related to authentication
- Allow to take control or leak information about payment methods or connected accounts
- Compromise the integrity or historicity of our transactions ledger
- Compromise the permission system
