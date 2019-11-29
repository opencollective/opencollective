# RFC 007 - Add Docker files to improve API setup

## Affected projects

- API

## Motivation

To make it as easy as possible to setup the api project locally.

## Solution

To leverage container technology, using Docker and docker-compose, to improve the API local setup.

## Benefits

- Operating System agnostic

Building the app inside a container guarantees that everybody is having a similar experience no matter the OS used.

- Easy to get up and running

With predefined commands that setup the app, developers don't have to worry about the right scripts or steps to get the app in the states they need.

There are predefined commands for development, testing, e2e and default.

- Developer experience

Until now the only way to run e2e tests is by setting up the API locally. This degrades the dev experience for developers that are only working on the frontend.

Suggestions to solve this limitation have come up; [#2531](https://github.com/opencollective/opencollective/issues/2531) and [#2556](https://github.com/opencollective/opencollective/issues/2556), but until we get there containers can help developers to have the environment they need by executing one command.

- Easy to maintain

This implementation provides predefined commands and the ability to run any current or future command using the same API as the predefined commands. The biggest point of change is the node version that needs to be updated in conjunction with the package.json and CircleCI config file.

## Alternatives

Some conversation have come up about creating [magic scripts](https://github.com/opencollective/opencollective/issues/2531#issuecomment-545900852) able to set up everything. (These would need to be OS dependent.)

Vagrant is another solution, [proposed by Benjamin Piouffle](https://github.com/opencollective/opencollective/pull/2644#discussion_r347774818), focused on creating cross-OS development environments through declarative configuration files. A drawback of this solution is the use of virtual machines that in general have worse performance than containers, as stated in this [post](https://www.vagrantup.com/intro/vs/docker.html).

## Proof of concept

See https://github.com/opencollective/opencollective-api/pull/2894

## Adoption / Transition strategy

The use of containers should be optional and we should provide support for both: the manual method (installing everything directly in the host) and the container method.
