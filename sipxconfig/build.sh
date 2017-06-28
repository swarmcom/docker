#!/bin/sh -e
REPO=git://github.com/sipXcom/sipxecs.git
NETWORK=${NETWORK:-"ezuce"}
SKIP_BUILD=${SKIP_BUILD:-""}

UID=$(id -u)
GID=$(id -g)

docker build $BUILD_FLAGS \
	--build-arg SKIP_BUILD=$SKIP_BUILD \
	--build-arg UID=$UID \
	--build-arg GID=$GID \
	-t $NETWORK/sipxconfig .
