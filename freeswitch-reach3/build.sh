#!/bin/sh -e
NETWORK=${NETWORK:-"ezuce"}
REPO=${REPO:-"https://freeswitch.org/stash/scm/fs/freeswitch.git"}
COMMIT=${COMMIT:-"$(../bin/get-commit $REPO)"}

echo $COMMIT > etc/commit

docker build $BUILD_FLAGS --build-arg REPO=$REPO -t $NETWORK/freeswitch-reach3 .
