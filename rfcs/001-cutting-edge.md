# RFC Frontend 001 - Cutting Edge

**TL;DR:**

As much as possible, we should always use the latest version of our dependencies. We'll use dedicated tools to properly automate that process.

## Motivation:

The Javascript ecosystem is moving fast, new version of libraries are regularly released, best practices are evolving. 

When nothing is done, dependencies in Javascript projects are getting outdated really quickly. This is generating a lot of noise (deprecation notices, security warnings) and hurt developer productivity (lost documentation). When updates are piling up, it's becoming time consuming and complicated to move forward. 

## Solution:

To solve the problem of outdated dependencies, one path is to be extremely pro-active, manage updates on a day to day basis, assisted by automation and continuous integration systems.

## Alternatives:

The alternative is to not actively manage dependencies updates and apply them manually on a case by case basis.

## Resolution:

 - By default, always use the latest stable LTS version of Node.js.
 - By default, always use the latest stable version of our dependencies.
 - When it's not possible to easily upgrade, open a ticket to properly document the issue.
 - Use the [Renovate](https://www.mend.io/renovate/) service to automate the process

## Exceptions:

 - For the time being, as we're not ready for ESM only dependencies, related updates should be ignored

## Updates:

- 2023-06-05: LTS Node, Renovate, Exceptions
