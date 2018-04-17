#!/bin/sh -e
REPO=${1:-"https://github.com/swarmcom/reach-ui.git"}
BRANCH=${BRANCH:-"master"}
NETWORK=${NETWORK:-"ezuce"}
HUB=${HUB:-"$NETWORK"}
COMMIT=${2:-"$(git ls-remote $REPO | grep refs/heads/$BRANCH\$ | sed 's/refs.*//')"}
echo $COMMIT > etc/commit

echo Using repository:$REPO branch:$BRANCH commit:$COMMIT
docker build $BUILD_FLAGS -t $HUB/reach-ui \
	--build-arg COMMIT=$COMMIT \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
