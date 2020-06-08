# RFC 011 - Best Practices with GraphQL

## Affected projects

- Frontend

## Motivation

It's not always clear what are the best practices when using GraphQL in our frontend codebase. This document aims to help with that.

## Best Practices

### Operation Name

When troubleshooting and observing GraphQL usage, it's nice to have great names so we can clearly identify what is the operation and wehere it's coming from.


All GraphQL queries and mutations should have a clear "Operation Name" that is unique within the project.

- It should be in PascalCase
- Should not contain `Query` or `Mutation` suffix.
- Should not contain `get` or `fetch` prefix.

Good

- `query LoggedInUser`
- `mutation CreateCollective`

### Variable name

All GraphQL queries and mutations should been assigned to a variable (usually a JavaScript `const`).

In most of the cases, it should be named like the "Operation Name", but:

- Like all variables in the codebase, it should be in camelCase.
- It should have a `query`, `mutation` or `fragment` suffix.

Good

- `const loggedInUserQuery =`
- `const createCollectiveMutation =`

### gql and gqlV2

All GraphQL queries and mutations needs to be wrapped in a `gql` tag, this is necessary for Apollo and also detected by Eslint and Prettier.

For requests to the GraphQL API v2, it should be `gglV2/* GraphQL */`, it's currently the only way to have it properly processed by Eslint and Prettier.

### With React HOC

Following existing practice and to improve readability, the GraphQL HOC should be first assigned to a variable:
- named liked the query or mutation
- prefixed by `add`.

Good:

```
const addCreateCollectiveMutation = graphql(createCollectiveMutation, {

export default addCreateCollectiveMutation(createCollectivePage);
```

### With React Hooks

Don't use Apollo HOC. useQuery and useMutation.


### Naming migration function

TODO

### Passing variables to mutation

TODO

## Adoption / Transition strategy

- A first manual migration will done after this RFC is accepted.
- Developers should consider recommandations from this RFC when contributing new code
- Following these recommandations is not mandatory for a PRs to be accepted
- Any developer is free to contribute refactored code following these recommandations
