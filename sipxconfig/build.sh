#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone --depth 1 https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout -b branch docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS -t $NETWORK/sipxconfig .
