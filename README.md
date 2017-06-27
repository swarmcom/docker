eZuce containers
================

Notes
=====

In order to build ReachMe container it is required to have access to ReachMe repo, therefore
an access token must be provided (https://github.com/settings/tokens) in form of TOKEN env variable.

This is work in progress, see [TODO](TODO.md)

Init
====

You need to have Docker version at least 1.9.0 (as this setup relies on docker network heavily).
Also you probably want to add your local user to docker group with `usermod -aG docker $(whoami)`

```sh
./build.sh
./run.sh

# You know what are you doing, right?
./hosts.sh >> /etc/hosts
```

ReachMe
=======

Please see [ReachMe README](reach/README.md) how to run ReachMe.


Meta container
==============

There is a docker meta container intended to build other containers in controlled environment named `ezuce-ci`.
In theory it should be possible to build all components with it, the only thing you need to provide is
access to hosts docker socket, see [run.sh](ezuce-ci/run.sh), and GitHub auth token to have
access to private repo's.

In ezuce-ci folder:

```sh
./build.sh $TOKEN
./run.sh $TOKEN
docker exec ezuce-ci ./build.sh
or
docker exec ezuce-ci 'cd reach && ./build.sh'
```

Environment variables
=====================

The intent is to specify `docker build` flags e.g. to pass --no-cache to forcefully rebuild.

```sh
BUILD_FLAGS -- flags to pass to `docker build` command.
```

Check also README.md under each branch to understand better what's going on 
=====================
