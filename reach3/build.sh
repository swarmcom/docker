#!/bin/sh -e
if [ -z $TOKEN ]
then
	echo Please set TOKEN env variable to access Reach private repo
	exit 1
fi
REPO=${1:-"https://$TOKEN@github.com/ezuce/reach3.git"}
BRANCH=${BRANCH:-"master"}
NETWORK=${NETWORK:-"ezuce"}
COMMIT=${2:-"$(git ls-remote $REPO $BRANCH | sed 's/refs.*//')"}
echo $COMMIT > etc/commit

SAFE_REPO=$(echo $REPO | sed s/$TOKEN//g)

echo Using repository:$SAFE_REPO branch:$BRANCH commit:$COMMIT
docker build $BUILD_FLAGS -t $NETWORK/reach \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
