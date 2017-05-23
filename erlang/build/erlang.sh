#!/bin/sh -e
cd ~

# Added below lines to install openjdk
echo 'deb http://deb.debian.org/debian jessie-backports main' \
      > /etc/apt/sources.list.d/jessie-backports.list
 
apt update -y

apt install --target-release jessie-backports \
      openjdk-8-jre-headless libssl-dev \
      ca-certificates-java \
      --assume-yes
## finish openjdk install 


curl -O -k https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x kerl
./kerl update releases
./kerl build 19.3 19.3
./kerl install 19.3 erlang
. erlang/activate
./kerl cleanup all
