#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone --depth 1 git://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout release-17.08
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS -t $NETWORK/sipxconfig .
