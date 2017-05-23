#!/bin/sh -e
# NETWORK=${NETWORK:-"ezuce"}
# REPO=${2:-"https://freeswitch.org/stash/scm/fs/freeswitch.git"}
# COMMIT=${1:-"$(../bin/get-commit $REPO)"}
#
# echo $COMMIT > etc/commit

docker build $BUILD_FLAGS -t ezuce/freeswitch .
