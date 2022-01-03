# Affected projects

We'll start with the API, but the practices we define and the libraries that we pick should ideally be the same across all projects.

# Motivation

It's a great experience for developers when the scripts they use have well crafted command-line interfaces that:
- Are able to document the usage properly
- Exit when arguments are invalid (wrong types/values, typos, etc.)
- Require a confirmation when touching sensistive things
- Can run in dry mode (= simulate, but don't touch anything)
- Are easy to implement and extend
- Are easy to unit-tests

# Solution

## Use a standard library

Using a library to implement command line interfaces:
- Provides documentation/help menus for free
- Catches typos and errors, can display usage suggestions in such cases
- Makes it easy to implement and document command-line options

Today the API uses [argparse](https://github.com/nodeca/argparse), a library inspired by the Python equivalent. I believe this library has some drawbacks that should make us more encline to use [commander](https://www.npmjs.com/package/commander):
- Commander has 21k stars, argparse 400
- Argparse has no documentation, you need to check the Python docs and the README (to understand the differences betweeen the two languages)
- Argparse uses Python's conventions with lowercase functions - which forces us to add ESLint exceptions all around our scripts

## Make all scripts run in DRY mode by default

Any script that is not read-only should run in DRY mode by default to prevent accidents. We can either achieve that through an environment variable (`DRY_MODE=FALSE ./my-script.js`) or through an argument (`./my-script.js --dryMode=off`).

TODO: Define best practice

## Ask confirmation for sensitive operations

We already have an helper to do that. A simple questions with a Yes/No answer (`Are you sure you want to delete ___? > Yes/No`) is usually enough.

## Being able to import scripts in unit tests

Goal: 
- Wrap scripts with a `if (!module.parent)`
- Pass `argv` through arguments (for an easy override in tests)

Example:

```es6
if (!module.parent) {
  main(process.argv)
    .then(() => process.exit())
    .catch(e => {
      if (e.name !== 'CommanderError') {
        console.error(e);
      }

      process.exit(1);
    });
}
```

We can eventually create a generic helper for that.

# Proof of concept

- https://github.com/opencollective/opencollective-api/pull/7003 showcases a first use of `commander` for a real-world use case.

# Adoption / Transition strategy

1. Discuss best practices then merge this RFC
2. Adopt for all new scripts
3. Migrate existing scripts
4. Get rid of `argparse` completely
