#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxivr/build .
docker create --name=sipxivr-build sipxivr/build
mkdir -p tmp
docker cp sipxivr-build:/usr/local/sipx tmp/
chmod 7777 tmp/*
docker build $BUILD_FLAGS -t $NETWORK/sipxivr .
docker rm sipxivr-build
docker rmi sipxivr/build
rm -rf tmp
