# RFC 011 - Best Practices with GraphQL

## Affected projects

- Frontend

## Motivation

It's not always clear what are the best practices when using GraphQL in our frontend codebase. This document aims to help with that.

## Best Practices

### Operation Name

When troubleshooting and observing GraphQL usage, it's nice to have great names so we can clearly identify what is the operation and where it's coming from.

All GraphQL queries and mutations should have a clear "Operation Name" that is unique within the project.

- It should be in PascalCase
- Should not contain `Query`, `Mutation` or `Fragment` suffix.
- Should not contain `get` or `fetch` prefix.

Good:

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

For requests to the GraphQL API v1, it should be `gqlV1/* GraphQL */`, it's currently the only way to have it properly processed by Eslint and Prettier.

### With React HOC

Following existing practice and to improve readability, the GraphQL HOC should be first assigned to a variable:
- named liked the query or mutation
- prefixed by `add`.

Good:

```
const addCreateCollectiveMutation = graphql(createCollectiveMutation);

export default addCreateCollectiveMutation(createCollectivePage);
```

### With React functional components (React Hooks)

Don't use Apollo HOC, use Apollo React Hooks: `useQuery` and `useMutation`.

### Naming mutation 'mutate' function

It's generally un-necessary to define the `mutate` function ourselves.

Bad:

```
const addEditConnectedAccountMutation = graphql(editConnectedAccountMutation, {
  props: ({ mutate }) => ({,
    editConnectedAccount: async connectedAccount => {
      return await mutate({ variables: { connectedAccount } });
    },
  }),
});
```

You can simply use the `name` parameter to achieve the same.

Good:

```
const addEditConnectedAccountMutation = graphql(editConnectedAccountMutation, {
  name: 'editConnectedAccount',
});
```

Beware of the updated syntax when using it.

Old:

```
await this.props.editConnectedAccount(connectedAccount);
```

New:

```
await this.props.editConnectedAccount({ variables: { connectedAccount } });

```

This syntax is aligned with `useMutation` from React Hooks so it's a nice thing for consistency.

### Passing variables to queries

By default Apollo HOC is able to fill GraphQL query variables by looking at component `props`. We rely on that in a few places.

Because this behavior is not well understood, it's clearer to pass `props` explicitely instead.

Example:

```
const hostDashboardQuery = gql`
  query HostDashboard($hostCollectiveSlug: String) {
    Collective(slug: $hostCollectiveSlug) {
      id
      ...
    }
  }
`;
```

Bad:

```
const addHostDashboardData = graphql(hostDashboardQuery);
```

Good:

```
const addHostDashboardData = graphql(hostDashboardQuery, {
  options: props => ({
    variables: {
      hostCollectiveSlug: props.hostCollectiveSlug,
    },
  }),
});
```

This problem is only existing with Apollo HOC and is not an issue when using React Hooks.

## Adoption / Transition strategy

- A first manual migration will done after this RFC is accepted.
- Developers should consider recommandations from this RFC when contributing new code
- Following these recommandations is not mandatory for a PR to be accepted
- Any developer is free to contribute refactored code following these recommandations
