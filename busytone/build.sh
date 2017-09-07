#!/bin/sh -e
REPO=${1:-"https://github.com/swarmcom/busytone.git"}
BRANCH=${BRANCH:-"master"}
NETWORK=${NETWORK:-"ezuce"}
COMMIT=${2:-"$(git ls-remote $REPO $BRANCH | sed 's/refs.*//')"}
echo $COMMIT > etc/commit

echo Using repository:$REPO branch:$BRANCH commit:$COMMIT
docker build $BUILD_FLAGS -t $NETWORK/busytone \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
