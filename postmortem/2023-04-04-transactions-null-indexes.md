# Database locked after running a migration for Transactions indexes

## What happened?

On 2023-04-04, we deployed a [migration](https://github.com/opencollective/opencollective-api/pull/8774) that was intended to re-create indexes on the Transactions table with soft-deleted rows excluded, in order to improve performance. The migration was tested locally and ran successfully on staging. However, when the migration was run on production it locked the entire Transactions table, causing a degradation of service.

## Analysis

Even though we ran the index creation with `CONCURRENTLY`, the numerous queries that are constantly hitting the `Transactions` table
seem to have conflicted with the migration, causing the table to lock. Our approach of dropping the old index and creating a new one
was too optimistic in this regard: all the queries we got between the drop and the creation were not using any index and highly contributed
to the degradation of performance.

After limiting queries (by putting the frontend in maintenance mode), cancelling the new index creation then restoring the old index, the
performance returned to normal.

## Timeline

- 2023-04-04 09:13 UTC: the deployment is triggered
- 2023-04-04 09:20 UTC: degradation of service is noticed
- 2023-04-04 09:XX UTC: the migration is killed, but the table remains locked
- 2023-04-04 09:XX UTC: we put frontend in maintenance mode
- 2023-04-04 09:XX UTC: other connections to the database are closed
- 2023-04-04 10:00 UTC: we start the restoration of the old index
- 2023-04-04 10:05 UTC: the restoration of the old index is complete
- 2023-04-04 10:08 UTC: we restore frontend and officially confirm that the issue is resolved

## What went well?

- The issue was detected quickly
- We quickly paired to investigate and resolve the issue
- The maintenance mode in the frontend was a good way to limit the impact of the issue while showing a clear message to users

## What could have been better?

- Should have insisted to get a review from another engineer who could have noticed the issue before merging the PR (PR was shared with the team, but not reviewed)
- This kind of migration should be run during specific maintenance windows
- Future migrations should use a different strategy: Create new index, then drop old (rather than the other way around)
- Even though the migration was tested on local prod and staging, we're still missing tools to run migrations in stressed environments

## Follow up actions

- Add a script to simulate production load locally (using a tool like https://github.com/tsenart/vegeta)
