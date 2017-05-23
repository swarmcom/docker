#!/bin/sh -e
apt-get -y update && apt-get -y upgrade

# Add below lines to install openjdk
echo 'deb http://deb.debian.org/debian jessie-backports main' \
      > /etc/apt/sources.list.d/jessie-backports.list
 
apt update -y

apt install --target-release jessie-backports \
      openjdk-8-jre-headless \
      ca-certificates-java \
      --assume-yes
## finish openjdk install 

apt-get install -y make build-essential zip unzip git wget curl  
apt-get -y clean

useradd -s /bin/bash -m user

