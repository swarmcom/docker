#!/bin/sh -e
TOKEN=$1
DOCKER_GROUP=${2:-"$(getent group docker | cut -d: -f3)"}
if [ -z $DOCKER_GROUP ]
then
	echo "Can't automatically deduce docker group, please provide: $0 token docker_gid"
	exit 1
fi

if [ -z $TOKEN ]
then
	echo Please provide a token to access private repo: $0 token [docker_gid]
	exit 1
fi

echo Building with docker group: $DOCKER_GROUP

REPO=https://github.com/jamhed/ci.git
COMMIT=${2:-"$(git ls-remote $REPO grep master | sed 's/refs.*//')"}
echo $COMMIT > etc/commit

docker build $BUILD_FLAGS -t ezuce/ci --build-arg TOKEN=$TOKEN --build-arg DOCKER=$DOCKER_GROUP .
