# Quick Start

This page will help you get the Open Collective software up and
running in your computer so you can audit the code, adapt it to your
needs, and maybe even contribute back with a fix for a bug or a new
feature. The options are limitless!!

## Retrieve the code

We host our code on [GitHub](https://github.com/opencollective) and we
need to download two repositories to get started:

```bash
$ mkdir -p ~/src/github.com/opencollective
$ cd ~/src/github.com/opencollective
$ git clone http://github.com/opencollective/opencollective-api/
$ git clone http://github.com/opencollective/frontend/
$ cd ~/src/github.com/opencollective/opencollective-api/
```

The task of setting up the development environment was automated using
two different tools: Vagrant & Docker. Pick the one you're most
comfortable with, since you only need one or another.

## Vagrant

If [Vagrant](https://www.vagrantup.com/downloads.html) is installed
and working, just run the following command:

```bash
$ vagrant up
```

If everything works, the API will be running at
`http://localhost:23060` and the Frontend will be running at
`http://localhost:23000`.

## Docker

If your tool of choice is [Docker](https://www.docker.com/get-docker),
make sure you also have
[docker-compose](https://docs.docker.com/compose) and then execute:

```bash
$ docker-compose -f docker/docker-compose.yml up --build
```

If everything works, the API will be running at
`http://localhost:13060` and the Frontend will be running at
`http://localhost:13000`.

## Conclusion

Both Vagrant & Docker offer the same development workflow. They mount
the current directory in the host machine (Your Computer!!) within
their file system and run the server under `nodemon` and the Frontend
under `next`. Both will reflect file system changes right away.
