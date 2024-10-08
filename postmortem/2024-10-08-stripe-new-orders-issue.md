# Invalid payment notifications sent to contributors

## What happened?

We created a script to move orders that were stuck in "New" status, and tried to sync them with the Stripe API. These "NEW" orders
were not unique: we could end up in states were two orders sharing the same payment intent ID could be created in the DB (one NEW, and one PAID).

In the initial fix, we addressed the "NEW" orders without noticing that these had "PAID" siblings.

## Impact

- Users were notified about successful charges that had already been recorded in the past.
- Users were notified about erroring charges that had already been recorded in the past.
- These orders were duplicated, which triggered yet new notifications.
- Transactions were also duplicated, which impacted the balances and transactions history.
- This did **not** actually charge users.

TODO: Add metrics (nb emails)

## Timeline

- 25/09/2024 13:05 UTC: We deployed the CRON job
- 26/09/2024 15:13 UTC: We started receiving support tickets
- 27/09/2024 00:56 UTC: Support shared the tickets in #internal-support
- 27/09/2024 05:50 UTC: The message was escaladed to engineering in a private security channel, thinking the issue may be related to an attack
- 27/09/2024 05:58 UTC: We pointed the stripe job as a potential root cause
- 27/09/2024 06:20 UTC: We disabled the CRON job responsible for the issue in production
- 27/09/2024: We produced a fix + migration and sent emails to affected users to explain the issue

## What went well?

- Quick fix/mitigation
- Mailchimp was helpful to make the email look good and work around sending rate limits

## What could have been better?

- An env variable to disable the CRON job would have helped to mitigate faster
- We should have synchronization jobs for everything that is webhook-based
- The initial implementation should have stronger data integrity checks (e.g. unique index on payment intent ID)
- The impact would have been more limited if we hadn't notified users. Either by being aware of it, or having some checks. Maybe for scripts, email sending should be explicit?
- Sending "sorry" emails via GMail was a mess (500 limit/day + SPF issues)
- Mailchimp, though helpful, is not really designed for one-off notification emails like that.

## Follow up actions

- Explore the idea of disabling notifications by default in script/CRON jobs and make it a mandatory parameter when adding a new script
- We to investigate whether the CRON job is still needed then remove if not, change the interval and re-enable otherwise
- We to add an index on Orders payment intent ID
- Check how many cancelled their contributions because of this. If the number/amount is significant, reach out to them.
