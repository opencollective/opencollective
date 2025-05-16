# Email Service Interruption Post-Mortem

## What happened?

On 2025-05-15, Open Collective experienced an email service interruption when our email provider (Mailgun) blocked our domain due to a high complaint rate. We determined that malicious actors had abused our signup form to generate unwanted emails, causing recipients to report these emails as spam. This triggered Mailgun's automated protection systems, resulting in our domain (opencollective.com) being temporarily restricted from sending emails.

## Impact

- Users were unable to receive transactional emails from opencollective.com. As email confirmation is required for account creation, new users were unable to complete signup at https://opencollective.com/create-account. Guest contributions remained functional as they don't require email verification. Already authenticated users or accounts with a password setup were able to use the platform normally, apart from receiving email notifications.
- Our support contact form, which relies on Mailgun as well, was also partially down during this time.

The issue affected all emails sent through our primary domain for approximately 14 hours.

## Timeline

[2025-05-16 09:14 UTC]: An engineer detected a new error in our monitoring system indicating that emails sent from our domain were being blocked by Mailgun and escalates the issue. The investigation starts immediately.
[2025-05-16 09:23 UTC]: Analysis of Mailgun logs revealed that our signup form had been targeted by spam actors.
[2025-05-16 09:58 UTC]: We deploy stronger rate limiting on our signup form and block all the IPs involved in the attack.
[2025-05-16 10:00 UTC]: We reach out to Mailgun support to explain the situation and request a review of our account, explaining what we already did to mitigate the issue and detail our plan to deploy additional measures in the coming hours.
[2025-05-16 12:00 UTC]: We release a CAPTCHA enforcement on our signup form.
[2025-05-16 12:40 UTC]: Seeing that Mailgun has not yet responded, we start preparing a migration plan to a backup email provider (Amazon SES) in case we don't hear back from them soon.
[2025-05-16 15:00 UTC]: Having received no response from Mailgun, we reach out to their chat support to urge them to review our account, explaining the urgency of the situation. The operator confirms that our account is under review and that they should receive an update within the hour.
[2025-05-16 17:18 UTC]: Having no news from Mailgun, we open another chat to follow up. The operator informs us that our account is still under review and informs us that we should hear from them within ~30mins.
[2025-05-16 17:36 UTC]: Our account is restored by Mailgun. We confirm that our emails are being sent again and that the issue is resolved.

## What went well?

- Quick identification of the root cause (signup form abuse).
- Rapid implementation of technical countermeasures.
- The existing implementation of rate limiting/captcha made it easy to deploy additional measures.

## What could have been better?

- We lacked advance warning from Mailgun before our domain was blocked, which would have allowed us to take preventive measures.
- We did not receive notification when our domain was blocked, which delayed our detection and response time.
- Mailgun support response/action time was slow.
- We did not have proactive monitoring for unusual signup patterns
- We did not have a backup email sending mechanism for critical communications

## Follow up actions

- Implement Amazon SES as a secondary provider to both explore cost reduction and improve email sending resilience.
- Implement proactive actions for unusual signup patterns (e.g. alerting, blocking IPs, etc.).
- Enforce CAPTCHA and rate limits more strictly on forms that trigger email sending to outside users.
