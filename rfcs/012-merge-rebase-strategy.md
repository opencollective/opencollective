# RFC 012 - Merge Settings/Merge Strategies

## Affected projects

All the projects under the [Open Collective organization](https://github.com/opencollective).

## Motivation

It's not always clear what merge strategy to use when merging PRs. Currently, core contributors are free to use
whatever they prefer when merging PRs. GitHub allows three ways,

1) Create a merge commit - All commits from the branch will be added  to the base branch via a merge commit.

2) Squash and merge - All commits will be combined into one commit and added to the base branch.

3) Rebase and merge - All the commits will be rebased and added to the base branch.

This RFC proposes a solution in terms of GitHub settings so that we stick to one method.

## Best Practice

I feel there's no best practice on this matter but different workflows that are suitable for different teams.
For Open Collective projects only core team members are merging, and we cannot possibly enforce all the 
community to interactively rebase Git history. Hence, currently we are mostly relying on squashing and merging. 

## Solution

[Suggest disabling `Create a merge commit` from the GitHub settings](https://docs.github.com/en/github/administering-a-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests) 
as it's probably not suitable for our use. Using that option always will create merge commits and we will not have 
a clean Git history. We could possibly also disable `Rebase and merge` as well although I would argue leaving it in case someone would like to explicitly include
several commits to the `main` branch. The squash and merge option should work for us in all cases. 

As an alternative or a stricter enforcement of this standard we can also add the [`Require linear history` branch protection rule 
to `main` branch](https://docs.github.com/en/github/administering-a-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule).