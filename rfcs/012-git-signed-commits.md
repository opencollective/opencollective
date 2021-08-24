# Affected projects

All projects, this is a developer [Git](https://git-scm.com/) configuration issue. Effecting mainly core developers of the Open Collective team.

# Motivation

Simply put the motivation is to extra security and adhering to best practices for Open Collective Git repos. 

Currently, [Git](https://git-scm.com/) is used as the version control system and [GitHub](https://github.com/) to host the code. One could perform a Git commit on their machine and push it to GitHub. Git has been designed in its default form to accept any username, email when committing. There's no guarantee just because the commit says that it was performed by user `X` it indeed was a commit by user `X`. 

More on this issue can be found at, https://mikegerwitz.com/2012/05/a-git-horror-story-repository-integrity-with-signed-commits

# Solution

Git already provides signing of commits; https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work. This could ensure that the commits actually comes from a trusted source. Adding one layer on top of GitHub security mechanisms. 

The suggested solution is basically as follows, 

- Generate a GPG key pair (summary of instructions can be found at, https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/generating-a-new-gpg-key)
- Upload the public GPG key to GitHub; https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account
- Configure Git for the signing key; https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/telling-git-about-your-signing-key
- Sign the commits; https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/signing-commits

**Note:** Also make sure to upload the public GPG key to a public keyserver such as https://keyserver.ubuntu.com so others can verify the signature. Ideally the core members should verify each other's public keys. 

After the initial setup is done as specified above the workflow for performing commits is exactly similar to what was done before except for adding the extra `-S` flag when committing; i.e: `git commit -S -m your commit message`

# Alternatives

To use the current practice of not signing commits. Might be okay if it's thought that core developer GitHub accounts are secure to a reasonable degree and hopefully will not be hacked. 

# Proof of concept

This commit for the RFC was performed as a signed commit (notice the GitHub Verified flag). And my public key can be found at, https://keyserver.ubuntu.com/pks/lookup?search=sudharakap%40mun.ca&fingerprint=on&op=index

# Adoption / Transition strategy

Enforcing this practice for all core developers at Open Collective going forward, requiring signing as mandatory by the use of [GitHub main branch protection rule; `Require signed commits`](https://docs.github.com/en/github/administering-a-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule).