Login Token Mismatch
====================

Summary
-------

Background: To approve expenses or approve collectives, we're sending notification emails. As a commodity, these emails were containing in approve/reject links a token to authenticate users in case they were not already authenticated.

When sending these emails, the token was the same for all admins, leading to admins being potentially authenticated as one of the other fellow admins.

Impact
------

All hosts and all collectives with multiple admins were impacted.

Timeline
--------

(Berlin, UTC+1)

- **2019-03-25 10:15**:
  we're contacted on our #support channel by a user reporting the problem, the investigation starts immediately.
- **2019-03-25 11:30**:
  the root cause is identified, a misuse of scope and variables in the notification code is discovered.
- **2019-03-25 12:00**:
  PR is issued, merged and deployed. https://github.com/opencollective/opencollective-api/pull/1822
- **2019-03-26 09:00**:
  follow up PR is issued, merged and deployed. https://github.com/opencollective/opencollective-api/pull/1826
- **2019-03-26 09:30**:
  JWT secret is rotated, invalidating all authentication tokens generated before this time.

Root Cause
----------

Misuse of variables in the notification code after a refactoring.

Resolution
----------

- **API**: fixing the code and deploying
- **API**: rotating JWT secret

Corrective and Preventative Measures
------------------------------------

- **API**: stop attaching tokens to email links, keeping that for Sign In / Sign Up flow.

Why we were lucky?
------------------

- The issue was responsively disclosed to us by a trusted user.
- The bug would only affect admins of the same collective/host, people who likely know each other and would not harm themselves.

What went well?
---------------

- Fast CI and deployment. Fast time to ship.
- Ability to invalidate tokens by rotating JWT secret.
- Responsive support.
