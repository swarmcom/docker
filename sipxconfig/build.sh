#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxconfig/build .
docker create --name=sipxconfig-build sipxconfig/build
mkdir -p tmp
docker cp sipxconfig-build:/usr/local/sipx tmp/
chmod 7777 tmp/*
docker build $BUILD_FLAGS -t $NETWORK/sipxconfig .
docker build -f Dockerfile.db $BUILD_FLAGS -t $NETWORK/postgres-init .
docker rm sipxconfig-build
docker rmi sipxconfig/build
rm -rf tmp
