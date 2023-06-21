# Introduce a headless (unstyled) components library

## Affected projects

- [Frontend](https://github.com/opencollective/opencollective-frontend)
- [Frontend template](https://github.com/opencollective/opencollective-frontend-template) (since it depends on Frontend components)

## Motivation

- Reduce the load on the engineering team by re-using components already built with UX/accessibility best practices
- Build new UI more easily, through a library of components that are already tested and documented
- Prepare the ground for introducing a [CSS library](https://github.com/opencollective/opencollective/pull/6694)

## Solution

<!--
Describe the proposed solutions with facts and arguments in favor of this change.
If it has some drawbacks, include them as well.
-->

## Alternatives

|                                   | Material Base                 | Headless UI | PrimeReact | Radix UI                         | ReaKit | Reach UI | React Aria |
| --------------------------------- | ----------------------------- | ----------- | ---------- | -------------------------------- | ------ | -------- | ---------- |
| Popularity (weekly npm downloads) | 3.3m                          | 1.1m        | 87k        | 1.9m (@radix-ui/react-primitive) | 165k   | n/a      | 163k       |
| Maturity                          | In beta (introduced Sep 2022) |             |            | Mature (first release Dec 2020)  |        |          |            |
| Maintenance                       |                               |             |            | Active                           |        |          |            |
| License                           | MIT                           | MIT         | MIT        | MIT                              |        | MIT      | Apache 2.0 |
| Tailwind Comp.                    | ✅                            | ✅          |            | ✅                               |        |          |            |
| **Supported components**          |                               |             |            |                                  |        |          |            |
| Modal                             | ✅                            | ✅          |            | ✅                               |        |          |            |
| Checkbox                          | ❌                            | ❌          |            | ✅                               |        |          |            |
| Toggle                            | ✅                            | ✅          |            | ✅                               |        |          |            |
| Tooltip                           | ❌                            | ❌          |            | ✅                               |        |          |            |
| Select                            | ✅                            | ✅          |            | ✅                               |        |          |            |
| Dropdown                          | ✅                            | ✅          |            | ✅                               |        |          |            |
| Collapsible                       | ❌                            | ❌          |            | ✅                               |        |          |            |

Note: Popularity is rated based on the number of GitHub stars and downloads, Maturity is based on the library's age and stability, and Maintenance is based on the frequency of updates and the responsiveness of maintainers. Compatibility with Tailwind is rated based on the level of official support or the availability of community-made integrations. The checkboxes for each library indicate whether they support the listed components, as requested.

## Proof of concept

<!-- If applicable, add a link to a PR or an example that demonstrate the change -->

## Adoption / Transition strategy

<!--
If applicable, how are we going to migrate existing code? How are we going to document and teach
that to ensure that existing and new contributors will acknowledge this change?
-->
