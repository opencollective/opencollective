# Member Invitations: Listing all Invitations Leak

## Summary

On Thursday, August 5th 2021, we got an email reporting that the user had access to see all Member Invitations through the Pending Invitations link in the user menu and they were worried it could use that to gain admin access to any collective.
The bug was quickly tracked down to a faulty member invitation query and actually didn't pose any security threat.

## Analysis

Around a week before the incident, the redesign of the Edit Team Members page was submitted for review by a recurrent contributor as a part of our bounty program. The issue required many refactors because it was an opportunity to migrate our mutators and resolvers to the new GraphQL V2 resolvers.

One of the key characteristics of the V2 resolvers is that we have different interfaces to our existing objects, for example: Collectives, Hosts, Funds, Individuals are existing implementations of the Account interface This means that the “Collective” term is a bit more specific and the new generic term that defines all of this is called Account. Now, when you want to load a specific account page by slug, you’re requesting GraphQL for an Account that has that slug and not necessarily a Collective.

Following the specifications for the new refactor, a new query interface was implemented for fetching MemberInvitations and naturally, the first implementation submitted by the user was carrying the former abstraction: its arguments were CollectiveId and MemberCollectiveId, following the abstractions existing in our database model. This was instantly caught in review and fixed with the new GraphQL V2 abstractions: Account and MemberAccount.

Although the code was reviewed multiple times by core team members, one error slipped: the query executed by this resolver was still searching for the arguments CollectiveId and MemberCollectiveId and since the input arguments were updated, these would always be undefined, and since they were undefined, the MemberInvitationQuery that should fetch MemberInvitations for a specific account would return all MemberInvitations in the DB.

This error was originally caught by the author after the code was deployed to production. The author opened a PR and submitted for the responsible core team member to review. The responsible core team member usually reads his notifications once as the first action of the day and since this was submitted after, it was bound to be caught on the next day.

The core team was notified about the issue by an email sent to our security email by a user that was worried this was a critical bug that would allow them to join any collective.
This was fortunately not the case, we were just wrongly displaying all open invitations as if it was meant to the logged in user.

## Impact

From 12:24PM to 7:40PM UTC, users were seeing all Member Invitations in the Pending Invitations page as if they were invited to those collectives.

## Timeline

(UTC August 5th, 2021)

- **12:24**
  Faulty PR is deployed to production.
- **13:21**
  Contributor submits patch PR for review.
- **19:31**
  Security email is posted on slack.
- **19:40**
  Contributor PR is deployed to production.

## Root Cause

Faulty refactor in the original PR: https://github.com/opencollective/opencollective-api/pull/6008

## Resolution

Fixed variables in patch 6408: https://github.com/opencollective/opencollective-api/pull/6408

## What went well?

- The review caught the inconsistency in the variable names.
- A patch was promptly submitted by the contributor.

## What could have been better

- Our existing resolvers should by default implement typing so contributors can take them as example.
- Writing more tests and request that from contributors.
- We could DM core team members as a way to ensure they're aware of important patches even though we notified them in GitHub.

## Special thanks

@snitin315 for patching the issue.
