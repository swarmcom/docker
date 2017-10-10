#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxrelay/build .
docker create --name=sipxrelay-build sipxrelay/build
mkdir -p tmp
docker cp sipxrelay-build:/usr/local/sipx tmp/
chmod 7777 tmp/*
docker build $BUILD_FLAGS -t $NETWORK/sipxrelay .
docker rm sipxrelay-build
docker rmi sipxrelay/build
rm -rf tmp
