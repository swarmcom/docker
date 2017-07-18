#!/bin/sh -e
REPO=${1:-"https://github.com/swarmcom/busytone.git"}
COMMIT=${2:-"$(git ls-remote $REPO | grep master | sed 's/refs.*//')"}
echo $COMMIT > etc/commit

BRANCH=${BRANCH:-"master"}
NETWORK=${NETWORK:-"ezuce"}

echo Using repository:$REPO branch:$BRANCH
docker build $BUILD_FLAGS -t $NETWORK/busytone \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
