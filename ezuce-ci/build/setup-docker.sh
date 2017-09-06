#!/bin/sh -e

apt-get update
apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common sudo

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get -y install docker-ce

delgroup $(getent group $DOCKER | cut -d: -f1)
addgroup --gid $DOCKER docker
usermod -G docker user
