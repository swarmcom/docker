#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout release-17.08
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxregistrar/build .
docker create --name=sipxregistrar-build sipxregistrar/build
mkdir -p tmp
docker cp sipxregistrar-build:/usr/local/sipx tmp/
docker build $BUILD_FLAGS -t $NETWORK/sipxregistrar .
docker rm sipxregistrar-build
docker rmi sipxregistrar/build
rm -rf tmp
