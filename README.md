Reach3 docker environment
=========================

This is the development version meaning each container must be built from scratch,
and each container has everything required to alter the code and compile it (inside a container).

Production images are made out of these development containers, see [export](export/README.md)

Notes
=====

In order to build the environment it is required to have access to private Reach3 repo, therefore
an access token must be [provided](https://github.com/settings/tokens) by setting TOKEN env variable.

Reach3 instance must have following containers running:

1. [reach](reach/README.md)
2. [rr](rr/README.md)
3. [freeswitch](freeswitch-reach3/README.md)
4. [timescale](timescale/README.md)

If you want to have UI, then also one (or both, if you're curious) of:

1. [reach-ui](reach-ui/README.md)
2. [reach-ui-jh](reach-ui-js/README.md)

In order to run automated test following containers must be running (in addition to above):

1. [busytone](busytone/README.md)
2. [freeswitch-agents](freeswitch-agents/README.md)

Optional containers (but highly recommended):

1. [kamailio](kamailio/README.md)
2. [nginx-ingress](nginx-ingress/README.md)
3. [grafana](grafana/README.md)

Continous integration:

1. [ezuce-ci](ezuce-ci/README.md)

Architecture
============

All images are derived from [base-os](base-os/README.md) container, reach3 and busytone in turn are derived from [erlang](erlang/README.md) container.

Installation
============

You need to have Docker version at least 1.9.0 (as this setup relies on docker network heavily).
Also you probably want to add your local user to docker group with `usermod -aG docker $(whoami)`

```sh
export TOKEN=... (see above)
./build.sh
./run.sh

# You know what are you doing, right?
./hosts.sh >> /etc/hosts
```

Use of environment variables
============================

The intent is to specify `docker build` flags e.g. to pass --no-cache to forcefully rebuild.

```sh
BUILD_FLAGS -- flags to pass to `docker build` command.
```

Check also README.md in each folder to understand the particular container.

Production images
=================

It is possible to create so-called production images out of development images. See [export/README.md](export/README.md)
