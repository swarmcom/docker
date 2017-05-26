#!/bin/sh -e
NETWORK=${NETWORK:-"ezuce"}
REPO=${2:-"https://github.com/sipXcom/freeswitch.git"}
COMMIT=${1:-"$(../bin/get-commit $REPO)"}

echo $COMMIT > etc/commit
cd src
if [ ! -d freeswitch ]; then
  git clone $REPO freeswitch
  cd freeswitch
  git checkout release-17.08
  cd ../
fi
cd ../

docker build $BUILD_FLAGS --build-arg REPO=$REPO -t $NETWORK/freeswitch .
