# RFC 012 - Merge Settings/Merge Strategies

## Affected projects

All the projects under the [Open Collective organization](https://github.com/opencollective).

## Current Practice

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
   
For the reasons mentioned above, this RFC proposes a solution in terms of GitHub settings in order to stick to one method when merging PRs,
whilst giving contributors the ability to choose a method they prefer(merging, interactive rebasing etc) for their own branches/PRs.

## Best Practice

There's no best practice on this matter but different workflows that are suitable for different teams.
For Open Collective projects only core team members are merging. It's hard or probably impossible to enforce all the 
community to interactively rebase Git history. Hence, currently we are mostly relying on squashing and merging PRs which are not 
interactively rebased and have multiple commits, or those which have merge commits from main branch. 

Whether contributors use interactive re-basing, or if they choose to use simple merging, a cleaner Git history could still be 
achieved if PRs are squashed before merging. 

Some major projects such as NextJS, React and Babel seem to use the same approach in maintaining their Git histories. Some examples are given below.

For NextJS; https://github.com/vercel/next.js/pull/25198. In this case the contributor uses lot of commit messages and also merge from `canary` (the default branch of NextJS) to their branch. 
However, the final result is just a single commit without any merges.

![image](https://user-images.githubusercontent.com/12435965/122803708-d158cc00-d27b-11eb-8f99-ac6d7a26fa43.png)

Similarly, here's a recent example for React; https://github.com/facebook/react/pull/21648. This seems a squash merge;

![image](https://user-images.githubusercontent.com/12435965/122802824-b20d6f00-d27a-11eb-8db9-10ba529bb9a6.png)

For Babel: https://github.com/babel/babel/pull/13419. Again this seems to be a squash merge;

![image](https://user-images.githubusercontent.com/12435965/122803003-f39e1a00-d27a-11eb-8f00-f34d480af450.png)

Therefore, it could be argued that the squash and merge approach is suitable and works in maintaining a linear Git history while
also making sure the contributors get full flexibility to choose how they arrange their branch commits.

### Downside of this approach

One downside is that when squashing and merging the person who merge needs to verify the commit title and description and make sure
it makes sense. The GitHub interface automatically creates a commit description by concatenating all the commits in the branch. 
Although this seems to work in most cases it's probably a good practice to see if the commit(s) make sense while merging. 

## Solution

[Disable `Create a merge commit` from the GitHub settings](https://docs.github.com/en/github/administering-a-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests) 
to help maintain a linear Git history. But keep the `Rebase and merge` option in case someone would like to explicitly include
several commits to the `main` branch. The squash and merge option should work for us in all cases. 

Also add the [`Require linear history` branch protection rule 
to `main` branch](https://docs.github.com/en/github/administering-a-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule) to 
avoid merge comments being written to the main branch.