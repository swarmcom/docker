#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout release-17.08
  cd ../
fi
cd ../

NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxproxy/build .
docker create --name=sipxproxy-build sipxproxy/build
mkdir -p tmp
docker cp sipxproxy-build:/usr/local/sipx tmp/
docker rm sipxproxy-build
docker rmi sipxproxy/build
docker build $BUILD_FLAGS -t $NETWORK/sipxproxy .

rm -rf tmp
