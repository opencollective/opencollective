# Security Policy

We believe that no technology is perfect and that working with skilled security researchers
is crucial in identifying weaknesses.

If you believe you've found a security bug in our service, we'll be happy to work with you
to resolve the issue promptly and ensure you are fairly rewarded for your discovery.

We will investigate legitimate reports and make every effort to quickly resolve any vulnerability.
To encourage responsible reporting, we will not take legal action against you nor ask law enforcement
to investigate you providing you comply with the current policy and more generally with the following guideline: Make a good faith effort to
avoid privacy violations, destruction of data, and interruption or degradation of our services.

## Eligibility and Responsible Disclosure

Only those that meet the following eligibility requirements may receive a monetary reward:

- You must be the first reporter of a vulnerability.
- The vulnerability must be a qualifying vulnerability.
- Any vulnerability found must be reported no later than 72 hours after discovery.
- You must send a clear textual description of the report along with steps to reproduce the issue, include attachments such as screenshots or proof of concept code as necessary.
- You must avoid tests that could cause degradation or interruption of our service (refrain from using automated tools, and limit yourself about requests per second).
- You must not leak, manipulate, or destroy any user data.
- You must not be a former or current employee of Open Collective or one of its contractor.
- You must wait for the issue to be fully fixed before exposing it publicly.
- There must be proof that, given realistic processing power and time, an exploit is possible.

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

## Contact

- Mail: security@opencollective.com
- Preferred languages: English
- If your issue is critical, you can use the PGP key below to encrypt your message

```
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=2kSo
-----END PGP PUBLIC KEY BLOCK-----
```

## Rewards

| Project       | Type            | Security requirement | Low  | Medium | High  | Critical |
| ------------- | --------------- | -------------------- | ---- | ------ | ----- | -------- |
| API           | API             | +++                  | \$100 | \$200  | \$300 | \$600    |
| Frontend      | Web Application | +++                  | \$100 | \$200  | \$300 | \$600    |
| PDF service   | API             | ++                   | \$50 | \$100   | \$200 | \$300    |
| Images        | API             | ++                   | \$50 | \$100   | \$200 | \$300    |
| REST          | API             | ++                   | \$50 | \$100   | \$200  | \$300    |

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

CVSS3 score:

- From 1 to 4 ==> Low
- From 4 to 7 ==> Medium
- From 7 to 9 ==> High
- From 9 to 10 ==> Critical

Things that we take into account to adjust the score for vulnerabilities:

- Everything related to authentication
- Allow to take control or leak information about payment methods or connected accounts
- Compromise the integrity or historicity of our transactions ledger
- Compromise the permission system
