# Affected projects

All projects.

# Motivation

When we create new files, there's no implicit or explicit convention about the file and folder names.

- Paths are not predictable, which may add complexity when autocomplete is not available.
- It gives this impression that files are unorganized.
- It may confuse new contributors.

# Solution

Adopt the following conventions.

### 1. Folders names should be kebab-case

> src/components/
> src/lib-utils/
> scripts/

### 2. File names should be kebab-case

> index.js
> src/pages/create-account.js
> docs/how-to-create-collective.md
> rfcs/008-naming-conventions.md
> img/logo-dark.png
> test/hello-world.js

### 3. JS files exporting a class or a component should take its name

This is an exception to the rule 2 to use PascalCase instead.

> src/components/SignUp.js
> src/lib/MyClass.js
> src/components/contribution-flow/ContributePayment.js

# Alternatives

We could use snake_case instead of kebab-case. It is a matter of taste and I don't know any arguments that would bring a clear benefit between one side of the other of the balance. We currently have both snake_case and kebab-case filenames in our codebase, but kebab case is the most used:

| Project  | kebab-case | snake_case |
| :------: | :--------: | :--------: |
| frontend |    324     |     74     |
|   api    |    189     |     79     |

# Proof of concept

This is what a typical project could look like:

```
.
├── package.json
├── src
│   ├── api
│   │   ├── GraphQLAPI.js
│   │   └── HttpAPI.js
│   ├── components
│   │   ├── collective-page
│   │   │   ├── Contributors.js
│   │   │   ├── GetAndGive.js
│   │   │   ├── Hero.js
│   │   │   ├── index.js
│   │   │   ├── JoinUs.js
│   │   │   ├── Mission.js
│   │   │   └── SuggestedCollectives.js
│   │   ├── Container.js
│   │   ├── Content.js
│   │   └── Logo.js
│   └── lib
│       ├── currency-utils.js
│       └── datetime-utils.js
├── test
│   └── my-component.js
└── webpack.config.js
```

# Adoption / Transition strategy

If adopted, this RFC should be implemented in all projects by creating pull request to migrate all filenames to match this convention.

We should also enforce it with ESLint by adding [eslint-plugin-filenames](https://www.npmjs.com/package/eslint-plugin-filenames) to https://github.com/opencollective/eslint-config-opencollective with the proper configuration set.
