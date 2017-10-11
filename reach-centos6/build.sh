#!/bin/sh -e
if [ -z $TOKEN ]
then
	echo Please set TOKEN env variable to access Reach private repo
	exit 1
fi
REPO=${1:-"https://$TOKEN@github.com/ezuce/reach-app.git"}
BRANCH=${BRANCH:-"master"}
NETWORK=${NETWORK:-"ezuce"}

COMMIT=${COMMIT:-"$(git ls-remote $REPO $BRANCH | sed 's/refs.*//')"}
echo $COMMIT > etc/commit

echo Using repository:$REPO branch:$BRANCH
docker build $BUILD_FLAGS -t $NETWORK/reach-centos6 \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
