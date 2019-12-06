# RFC 008 - Use GitHub Actions for CI

## Affected projects

- API
- Frontend
- Bot
- Invoices
- Images
- BackYourStack

## Motivation

GitHub Actions is now available and it could provide a better experience than CircleCI for our setup.

- Deep integration with GitHub obviously
- 100% Free (because we're Open Source). We don't want to pay for CI if we don't have to.
- Faster because of bigger limits in the number of concurrent jobs (CircleCI allows us 4 concurrent jobs with our current free plan).

## Solution

- Implement a CI configuration using GitHub Actions Workflows

## Alternatives

- Do nothing and keep current setup with CircleCI
- Pay for higher concurrency limits with CircleCI
- Another CI platform

## Proof of concept

- API: https://github.com/opencollective/opencollective-api/pull/2183
- Frontend: https://github.com/opencollective/opencollective-frontend/pull/3111

## Potential Problems

- CircleCI might be more mature and powerful
- CircleCI might be faster in execution (but with queues)

## Adoption / Transition strategy

- Start a trial period running CircleCI and GitHub Actions simultanously.
- After a few weeks, evaluate both tools and switch to GitHub Actions if the experience is better.
