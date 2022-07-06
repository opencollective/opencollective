# Leak core contributors emails

## Summary

On Sunday 22th December, we got informed of a security issue on our endpoint to add members
to a Collective that could have been abused to harvest users emails.

## Impact

We have good confidence that this issue has not been exploited at scale to harvest users
emails. Because we have an history of members added/deleted, it's easy to know how many
members have been added/removed for each collective. No suspicious activity was identified
by looking at these data.

There's no guarantee however that the issue has not been exploited to target specific users.
Though we didn't receive any support complaint of users being added as admins of collectives
without their consent, we should consider that this issue may have been exploited in this sense.

## Timeline

(Paris, UTC+1)

- **2019-12-22 17:24**
  The [Tauri security team](https://github.com/tauri-apps/tauri) (reporter) tries to contact us
  on `security@opencollective.com`, unfortunately the address bounces (issue fixed since).
- **2019-12-22 17:30**
  Reporter sends the report to `pia@opencollective.com`
- **2019-12-22 17:37**
  Pia forwards the report to the engineering team
- **2019-12-22 18:30**
  Engineering team sees the report and quickly tries to reproduce the issue
- **2019-12-22 18:46**
  After reproducing successfully, an update is sent to reporter to confirm the reception
- **2019-12-22 19:12**
  We deploy a mitigation on production to use `bcc` instead of `cc` in emails
- **2019-12-23 09:30**
  After more investigation, we realize that there's a deeper design issue involved and
  decide to prioritize an invitation email feature to make sure that invited users must accept
  the invitation before being added to the members of the collective
- **2019-12-24 14:30**
  New invitation feature is pushed to production, issue is considered as resolved

## Root Cause

The reported issue originated in the email to invite new members being cc-ed to
the admins in https://github.com/opencollective/opencollective-api/blob/4a400f0c568dddce64f29d1e108671d812c64c25/server/models/Collective.js#L637.

But we also had a deeper design flaw: we need to make sure that these members **accept** the
invitations to join the core contributors of a collective (and thus that they accept to share
their email addresses) first. Otherwise it's easy to just add users as contributors to your
collective to harvest their email. This particular issue may have been there at the time of
implementation because it was already possible to add users by their ID: https://github.com/opencollective/opencollective-api/blob/4a400f0c568dddce64f29d1e108671d812c64c25/server/models/Collective.js#L710

However the recent changes in https://github.com/opencollective/opencollective-api/commit/9454292413c8177aa06a96f4d68cdef89d90c3cd#diff-768438be827d00a869e92ca592010413 made it possible
to add members by their collective ID, introducing a new way of exploiting this issue.

## Resolution

- Mitigation: [Use `bcc` rather than `cc`](https://github.com/opencollective/opencollective-api/pull/3090)
- Implement a member invitation feature: [Frontend](https://github.com/opencollective/opencollective-frontend/pull/3232) + [API](https://github.com/opencollective/opencollective-api/pull/3096)

## What went well?

- Despite receiving the report on a Sunday, we were able to react pretty quickly: investigation
  started in less than an hour, mitigation was deployed less than 2 hours after the report.
- The security policy provided a good framework. We had a rational and documented basis to
  estimate the bounty amount.

## What could have been better

- Working on the Collective picker to add users as members of the collective a few weeks ago,
  we should have realized that the design we introduced was flawed. We lacked of critical thinking and reproduced
  what existed for adding a user by ID without thinking that it could be exploited to harvest data.

## Special thanks

Special thanks to the [Tauri security team](https://github.com/tauri-apps/tauri) (https://opencollective.com/tauri)
for sending us a very detailed report on the issue, as well as suggestions on how to fix it.
According to our [Security Policy](https://github.com/opencollective/opencollective/blob/main/SECURITY.md),
the `High` status of this issue make them eligible for a \$200 bounty.
