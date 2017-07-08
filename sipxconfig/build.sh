#!/bin/sh -e
REPO=git://github.com/sipXcom/sipxecs.git
BRANCH=${BRANCH:-"docker-sipxconfig"}
NETWORK=${NETWORK:-"ezuce"}
SKIP_BUILD=${SKIP_BUILD:-""}

UID=${UID:-"$(id -u)"}
GID=${GID:="$(id -g)"}

docker build $BUILD_FLAGS \
	--build-arg SKIP_BUILD=$SKIP_BUILD \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	--build-arg UID=$UID \
	--build-arg GID=$GID \
	-t $NETWORK/sipxconfig .
