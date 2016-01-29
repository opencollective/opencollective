# dev
Development rules and onboarding

## Developer experience

We care about developer experience. Any repo should be able to be installed locally with just a `npm install` command as much as possible.

- All scripts should be referenced in `package.json` so that they can be run with `npm run $script`
- The `README.md` should be kept up to date and should describe the deployment to the different environments
- We use "[config](https://www.npmjs.com/package/config)" to manage environemnt variables.
- Production or test environment variables should only be kept on heroku (you can access them using the command `heroku config --json --app opencollective-staging-app`

## Javascript coding rules

- We use ES6 syntax (arrow functions, `const`, 
- We use string interpolation (```const str = `hello ${var}`;```)
