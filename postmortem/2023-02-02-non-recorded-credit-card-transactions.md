# Non recorded credit card transactions

## What happened?

We had credit card transactions that appeared as successful (confirmation page) but not recorded in the ledger.

Also, in some cases, people didn't get the success page because of an unrelated bug (redirect to 404). This can explain why there were retrying that much.

## Analysis

We are currently releasing updates to the contribution flow to support more payment methods. Only Fiscal Hosts using the new feature were affected (OSC, OCF, Europe and Platform 6).

People using a new Credit Card for the first time were affected by the issue.

With this new flow, transactions are normally recorded when we receive a webhook event. But here the event was ignored because the Order status was NEW instead of the expected PROCESSING.

Why was it NEW instead of PROCESSING? We removed the update to PROCESSING and the Order was left with status NEW. And the webhook was not accommodated for the change and was expecting status PROCESSING

https://github.com/opencollective/opencollective-api/pull/8464/files#diff-6bfae61d9f05877d4f96985e5c6158ed8c842db0969271aba8dc76b0909f1d48R101

## Extra factors:

Lack of definition of Order Status?

## Timeline:

- 2023-01-31 18:30 UTC: changes merged
- 2023-01-31  20:56 PM UTC: changes deployed in production
- 2023-01-31 10:42 UTC: changes deployed in production
- 2023-02-02: some users contact support because they're not seeing their contributions
- 2023-02-02 07:48 UTC: notice from the support team about user complains
- 2023-02-02 08:42 UTC: rollback to latest stable version
- we worked on a release to fix the issue https://github.com/opencollective/opencollective-api/pull/8497
- we worked on a script to fix the impacted transactions https://github.com/opencollective/opencollective-api/pull/8499
- all affected customers contacted by email before we proceeded with the script
- end of day: fix deployed and transactions recorded

## What went well?

- No data lost, we can always resyncronize with Stripe
- Context shared between multiple people in multiple timezones

## What could have been better?

- more than 24 hours in production without noticing
- more manual testing, especially for a critical feature
- E2E coverage for the feature
- changes not deployed consciously in production
- no alert or metric that warned us

## Follow up actions:

E2E coverage for the updated contribution flow (already being implemented)
