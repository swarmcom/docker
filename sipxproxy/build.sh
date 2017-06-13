#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout release-17.08
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS -t $NETWORK/sipxproxy .
