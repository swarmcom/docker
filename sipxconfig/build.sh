#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone --depth 1 https://github.com/swarmcom/docker.git
  cd sipxecs && git checkout docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS -t $NETWORK/sipxconfig .
