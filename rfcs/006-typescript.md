# RFC 005 - Use Typescript on the API

## Affected projects

- API

## Motivation

As discussed during the Brussels team retreat, using Typescript on the API could bring
interesting benefits such as:

- Better error detection

[It is said](http://ttendency.cs.ucl.ac.uk/projects/type_study/documents/type_study.pdf) that
types can help to prevent ~15% bugs. They are especially useful to specify what's nullable,
what's not and the expected return types. Issues like https://github.com/opencollective/opencollective/issues/1596
could have been prevented by using Typescript.

- Cleaner patterns

By providing `interface` and `enum` types out of the box, Typescript makes the code cleaner
and easier to understand in places that use them.

- Developer experience

IDEs like VSCode (through IntelliSense) [are able to improve autocompletion](https://code.visualstudio.com/docs/languages/typescript)
and errors detection thanks to Typescript.

- Smarter code refactoring

Type safety make the refactors safer.

## Solution

For the initial implementation:

- All the code is still compiled with babel (thanks to `@babel/preset-typescript`)
- Type checking only applies to file ending with `.ts`
- CI will check for types errors
- Typescript will only report errors with `npm run type:check` and in the IDE

## Alternatives

Flow is a strong alternative to Typescript. I don't have any pros/cons for it but
I personally favor the second because I have some expenrience with it.

## Proof of concept

See https://github.com/opencollective/opencollective-api/pull/2183

## Adoption / Transition strategy

We don't have a plan to migrate the existing codebase for now, nor to enforce it for all new
developments. However, we should encourage its usage for issues like https://github.com/opencollective/opencollective/issues/2274
where type checking and interfaces have a lot of benefits to offer.
