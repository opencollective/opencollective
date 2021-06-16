# RFC 012 - Merge Settings/Merge Strategies

## Affected projects

All the projects under the [Open Collective organization](https://github.com/opencollective).

## Motivation

It's not always clear what merge strategy to use when merging PRs. Currently, core contributors are free to use
whatever they prefer when merging PRs. GitHub allows three ways,

1) Create a merge commit - All commits from the branch will be added  to the base branch via a merge commit.

2) Squash and merge - All commits will be combined into one commit and added to the base branch.

3) Rebase and merge - All the commits will be rebased and added to the base branch.

### Benefits

- Core contributors can choose any particular method that they see fit. Sometimes a PR would contain unnecessary 
commits which will pollute the version history and thus a rebase or a squash makes sense. Other times it maybe that
  all the commits in the PR adds value. 
  
### Downsides

The main downside of this is that we are assuming that the person who made the branch/PR will keep the Git history clean
on that branch. For this purpose we have guidelines; https://github.com/opencollective/opencollective-api/blob/main/CONTRIBUTING.md. 

These guidelines propose interactive rebasing which comes with the following downsides.

1) Most new contributors and especially ones who are not familiar with Git will find this confusing.

2) Doing interactive re-bases for larger PRs can be time consuming when there are conflicts. Since the conflicts
needs to be solved for each commit separately rather than as a whole. While merging seems easier since it takes the whole diff
   and applies it in one go.
   
For the reasons mentioned above, this RFC proposes a solution in terms of GitHub settings so that we stick to one method
whilst giving contributors the ability to choose whatever method they prefer.

## Best Practice

I feel there's no best practice on this matter but different workflows that are suitable for different teams.
For Open Collective projects only core team members are merging, and we cannot possibly enforce all the 
community to interactively rebase Git history. Hence, currently we are mostly relying on squashing and merging. 

However, given that enforcing interactive re-bases for all branches are impossible I would argue we need to enforce a standard
on our end (when merging). Whether contributors use interactive re-basing or not, or if they choose to use simple merging, we could
still have a cleaner Git history if we always make sure to squash and merge PRs. 

### Downside of this approach

One downside is that when squashing and merging the person who merge needs to verify the commit title and description and make sure
it makes sense. The GitHub interface automatically creates a commit description by concatenating all the commits in the branch. 
Although I don't see this as a problem since even for an interactively re-based branch; while merging it's probably good practice
to see if the commit(s) make sense. 

## Solution

[Suggest disabling `Create a merge commit` from the GitHub settings](https://docs.github.com/en/github/administering-a-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests) 
as it's probably not suitable for our use. Using that option always will create merge commits and we will not have 
a clean Git history. We could possibly also disable `Rebase and merge` as well although I would argue leaving it in case someone would like to explicitly include
several commits to the `main` branch. The squash and merge option should work for us in all cases. 

As an alternative or a stricter enforcement of this standard we can also add the [`Require linear history` branch protection rule 
to `main` branch](https://docs.github.com/en/github/administering-a-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule).