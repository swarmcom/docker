eZuce containers
================

Init
====

You need to have Docker version at least 1.9.0 (as this setup relies on docker network heavily).

```sh
build.sh
run.sh
hosts.sh >> /etc/hosts
```

Environment variables
=====================

The intent is to specify docker build flags e.g. to pass --no-cache to forcefully rebuild.

```sh
BUILD_FLAGS -- flags to pass to build command for every image
```

TODO
====

1. Parametrize Reach with Mongo, Redis, sipXcom and FreeSWITCH references
2. Move Reach UI to separate container?
3. Actually run sipXcom and configurator
