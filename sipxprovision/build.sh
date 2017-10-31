#!/bin/sh -e
cd src
if [ ! -d sipxecs ]; then
  git clone  https://github.com/sipXcom/sipxecs.git
  cd sipxecs && git checkout docker-sipxconfig
  cd ../
fi
cd ../
NETWORK=${NETWORK:-"ezuce"}
docker build -f Dockerfile.build -t sipxprovision/build .
docker create --name=sipxprovision-build sipxprovision/build
mkdir -p tmp
docker cp sipxprovision-build:/usr/local/sipx tmp/
cp conf/sipxprovision.sh tmp/sipx/bin/
chmod 7777 tmp/*
docker build $BUILD_FLAGS -t $NETWORK/sipxprovision .
docker rm sipxprovision-build
docker rmi sipxprovision/build
rm -rf tmp
