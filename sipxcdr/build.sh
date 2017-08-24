#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxcdr/build .
docker create --name=sipxcdr-build sipxcdr/build
mkdir -p tmp
docker cp sipxcdr-build:/usr/local/sipx tmp/
cp conf/sipxcdr.sh tmp/sipx/bin/
chmod 7777 tmp/*
docker build $BUILD_FLAGS -t $NETWORK/sipxcdr .
docker rm sipxcdr-build
docker rmi sipxcdr/build
rm -rf tmp
