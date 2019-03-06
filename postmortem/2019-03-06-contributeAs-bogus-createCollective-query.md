contributeAs bogus createCollective query
=========================================

Summary
-------

When donating on behalf of a collective, at "Contribute As" step, a bogus GraphQL query was preventing users to go through.

It was later discovered that impacted users could also be logged out and prevented to login again.

Impact
------

According to the data in the database, up to 11 users (including us) were affected by this issue. 2 were reported to support.

Timeline
--------

(UTC+1)

- **2019-03-04**:
  as part of our normal process, a PR refactoring recompose to hooks is merged:
  https://github.com/opencollective/opencollective-frontend/pull/1383
- **2019-03-05 11:00**:
  as part of our normal process, a deploy to frontend is triggered, including the "hooks" change
- **2019-03-05 19:45**:
  a user contact us in #support channel, reporting an error when donating on behalf of a collective
- **2019-03-05 21:00**:
  François takes over the issue
- **2019-03-05 21:20**:
  after investigation, a frontend rollback is triggered, fixing the donation issue
- **2019-03-05 21:30**:
  a second issue affecting login is reported by Pia and confirmed by François
- **2019-03-05 21:40**:
  out of caution, an API rollback is triggered, without effect
- **2019-03-05 22:30**:
  after investigation, a manual SQL query is executed in production to delete the corrupted data, fixing the second issue

Root Cause
----------

- **Frontend**: In the contribution flow, a refactored code was triggering a bogus createCollective GraphQL mutation, leading to a GraphQL error, reported as is to the client
- **API**: In the createCollective GraphQL mutation, unsufficient checks were allowing a bogus query to create an invalid collective entry
- **API**: In the loggedinUser GraphQL query, corrupted data would trigger GraphQL errors
- **Frontend**: loggedinUser response containing GraphQL errors prevented the response to be handled by the client

Resolution
----------

- **Frontend**: rollback to latest stable version, without the problematic change
- **Database**: deletion of the corrupted data

Corrective and Preventative Measures
------------------------------------

- **Frontend**: E2E tests should cover Donation on behalf of the collective in the Contribution Flow
- **API**: createCollective mutation should checks more strictly data input
- **Frontend**: GraphQL responses containing errors should not systematically be considered as errors

What went well?
---------------

- Efficient Heroku rollbacks
- Small scale release
- Responsive support
