# RFC: Migrating e2e tests from Cypress to Playwright

## Affected projects

- [Frontend](https://github.com/opencollective/opencollective-frontend)
- CI jobs for projects that run frontend's e2e tests

## Motivation

The motivation for this RFC mostly originates from pain points we have with Cypress:

- Tests reliability: Cypress tests are flaky and often fail for no apparent reason. [Playwright](https://playwright.dev/) claims to be more reliable, and various [blog posts](https://www.qawolf.com/blog/why-qa-wolf-chose-playwright-over-cypress) and comments over the Internet seem to confirm this.
- Developer experience: Cypress is slow to start and slow to run tests, things are difficult to debug.
- Incomplete implementation: Cypress does not support some important features, such as `.hover()`.
- Pricing limitations: Cypress purposely limits features such as parallel test execution or video recording to paid plans, which given our heavy usage of e2e tests, would be very expensive.
- Project health: Cypress is a VC-backed company with a proprietary product. There is no guarantee that the project will remain open source or that the company will remain in business. Playwright is an open source project backed by Microsoft; it has overpassed Cypress in terms of popularity over the last year: https://ossinsight.io/analyze/cypress-io/cypress?vs=microsoft%2Fplaywright#overview.
- Performance: naive benchmarking on our codebase show ~25% faster execution time with Playwright.
- Playwright seems to have a better support for [iframes](https://playwright.dev/docs/api/class-frame), which is something we use a lot in our tests (e.g. Stripe Connect) and that is not well supported by Cypress.

# Drawbacks

- Learning Curve: There may be a learning curve for developers familiar with Cypress but new to Playwright.
- Migration Effort: Depending on the complexity of our tests, migration could require significant effort.

## Alternatives

An alternative to this change would be to continue using Cypress for our e2e tests. Things like https://sorry-cypress.dev/ could help with the parallelization issues. However, this would not address the other issues mentioned above.

## Proof of concept

- [Frontend PR](https://github.com/opencollective/opencollective-frontend/pull/9799) to migrate 2 tests and configure CI for Playwright.

## Adoption / Transition strategy

The transition to Playwright will be carried out in phases to minimize disruption. Initially, a small set of tests will be migrated and the team will be trained on Playwright. Documentation will be updated to reflect the new testing framework. Once the team is comfortable with Playwright, the remaining tests will be gradually migrated.

We can also decide to start with migrating only the tests that are [flaky](https://github.com/opencollective/opencollective/issues/6484) with Cypress.
