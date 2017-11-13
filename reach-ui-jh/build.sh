#!/bin/sh -e
BRANCH=${BRANCH:-"jamhed-devel"}
NETWORK=${NETWORK:-"ezuce"}

REPO=${1:-"https://github.com/swarmcom/reach-ui.git"}
COMMIT=${2:-"$(git ls-remote $REPO | grep $BRANCH | sed 's/refs.*//')"}

echo $COMMIT > etc/commit

echo Using repository:$REPO branch:$BRANCH
docker build $BUILD_FLAGS -t $NETWORK/reach-ui-jh \
	--build-arg COMMIT=$COMMIT \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
