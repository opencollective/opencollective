# Migrate the API to EMS modules

## Affected projects

- [API](https://github.com/opencollective/opencollective-api)

## Motivation

- Node.js new official standard format for packaging code is [ECMAScript modules (ESM)](https://nodejs.org/api/esm.html#introduction)
- Some Node.js packages are now migrating to ESM and sometimes do not provide the packaging in [CommonJS](https://nodejs.org/api/modules.html#modules-commonjs-modules) (the previous standard). Its possible to use them, but importing ESM from CommonJS required async code that is awkward to use and propagates async behaviour across imports in a non-intuitive way.
- Importing CommonJS from ESM is transparent and supported.
- By using ESM with our NodeJS version, only TypeScript code would need to be transpiled, as all other code features are already supported native by NodeJS. This removes a dependency on Babel.

## Changes from CommonJS to ESM

- Relative imports must include the full path to the import source, including any extensions. Directory imports with implicit `index.js` is not allowed.
  - e.g. A directory import

    ```diff
    -   import models from `./server/models';
    +   import models './server/models/index.js';
    ```

  - e.g. A file import

    ```diff
    -   import { reportErrorToSentry } from './server/lib/sentry';
    +   import { reportErrorToSentry } from './server/lib/sentry.js';
    ```

  - There is a special case when dealing with TypeScript files, the import must use a `.js` extension even if the file is `.ts`. This seems to be well supported by tooling.

    ```diff
    // bar.ts is a TypeScript source file
    -   import foo from `./bar`
    +   import foo from `./bar.js`
    ```

- `__dirname` and `__filename` are undefined in ESM.

  Code that uses these variables must be refactored to ESM alternatives:

  ```js
  import { URL } from 'url'; 
  const __filename = new URL('', import.meta.url).pathname;
  ```

  ```js
  import url from 'url';
  const __dirname = url.fileURLToPath(new url.URL('.', import.meta.url));
  ```

- `module` is undefined in ESM. Scripts that can be both imported and executed, need to check this differently.

  ```js
  import { pathToFileURL } from 'url';

  export function run() {
    // some function
  }

  // is being executed as a script
  if (import.meta.url === pathToFileURL(process.argv[1]).href) {
    run();
  }
  ```

- `require` is undefined. Scripts that need `required` need to be refactored.

  ```js
  import { createRequire } from 'node:module';
  const require = createRequire(import.meta.url);
  // eslint-disable-next-line import/no-commonjs
  const cloudflareIps = require('cloudflare-ip/ips.json');
  ```

- ESM imports are immutable, test libraries for mocking and stubbing imports do not work with ESM. `sinon` would have to be replaced by an alternative and tests refactored.

  - [testdouble](https://github.com/testdouble/testdouble.js) is an alternative that plugs into NodeJs module loader to provide this function.

    ```js
    beforeEach(async () => {
      const transferWiseLibMock = await td.replaceEsm('../../../server/lib/transferwise.js');
      // getTransfer is a testdouble that can be used to stub and verify calls to it.
      getTransfer = transferWiseLibMock.getTransfer;

      // cron is the test subject, imported after replacing the ESM dependency above.
      const cron = await import('../../../cron/daily/check-pending-transferwise-transactions.js');
      checkPendingTransfers = cron.run;
    });

    it('test', () => {
      td.when(
          getTransfer(
            td.matchers.anything(), 
            td.matchers.anything(),
          )
      ).thenResolve({
        status: 'outgoing_payment_sent',
        id: 1234,
      });
    });
    ```

- `babel-loader` needs to be replaced by [ts-node](https://github.com/TypeStrong/ts-node) in order to execute the development live-reload API and execute crons. `ts-node` supports transpiling TypeScript with ESM support.

  ! This means dropping babel transpilation. This is not an issue at this moment as all features used in source are currently supported by our NodeJS version.

  ```json
  "script": "ts-node-esm $1",
  ```

- `sequelize` imports migration files using `require`, meaning they are imported as `CommonJS`. To deal with this, migrations would have to be defined with a `.cts` or `.cjs` extension to indicate CommonJS format to the loader. This also means that importing server code from migrations (something that we do sometimes) would require async imports to cross the CommonJS and EMS boundary.

## Unknowns

With the exception of tests (unit and end-to-end), these migrations have been tested, code compiles and executes. However, since tests were not migrated, verification of runtime changes is still pending.

## Alternatives

Don't migrate to ESM. It would still be possible to use ESM modules and keep up to date with the ecosystem by making use of async imports.

## A plan to migrate

- Before changing the module type.

  - The changes to import paths can be made with an existing [codemod](https://github.com/opencollective/opencollective-api/pull/9019/files#diff-7341deb36778f7c94fa66088ec984375d622ee86e364fd89e9ae075683f79268) and officially adopted as a style choice.

  - Adopting `.cts` and `.cjs` extensions for new sequelize migrations to make clear they are CommonJS files. Existing migrations can be archived without changes.

  - Adopting and migrating stubs and mocks to `testdouble` as a way to ensure compatibility with ESM. Code changes would still be required when the module type is changed.

  - Remove dependency of `babel` and adopt only code features available on our current NodeJS version. This is already the case, but can be a concious choice.

  - Adopt `ts-node` for development environment and executing scripts and crons. This tool natively supports ESM in case of a migration and transpiles TypeScript during execution.

- Making the module type change

  - Change the `package.json` module type to ESM. All files without `cts` or `cjs` extensions are now considered ESM.
  - Files using `__dirname` or `__filename` can be codemod to the new format.
  - Test cases using `testdouble` refactored to use the `replaceEsm` import method.
  - Validate unit tests and e2e tests.
  - Migrate API dist build to `tsc`.

## Questions

- Why not just adopt new files with `mjs` or `mts` extensions so they are considered ESM modules? Or alternatively, just rename everything to `cjs` or `cts` extensions and change the default module type to ESM.

  This just perpetuates the issue, as most of our codebase would still be CommonJS and importing new code would require an async import.

- Do we need to remove the dependency on Babel?

  In the POC, `babel-loader` was not able to work with the ESM/TypeScript environment. It was replaced by `ts-node-esm`. If babel cannot be used in the development and script/cron running environment, we should not depend on it for production builds.

## Proof of Concept

<https://github.com/opencollective/opencollective-api/pull/9019>
