#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone --depth 1 git://github.com/sipXcom/sipxecs.git
fi
cd sipxecs && git pull
cd ../..
echo `pwd`
NETWORK=${NETWORK:-"ezuce"}
docker build $BUILD_FLAGS -t $NETWORK/sipxcom .
