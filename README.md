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

```sh
./build.sh
./run.sh

# You know what are you doing, right?
./hosts.sh >> /etc/hosts
```

Environment variables
=====================

The intent is to specify `docker build` flags e.g. to pass --no-cache to forcefully rebuild.

```sh
BUILD_FLAGS -- flags to pass to `docker build` command.
```


