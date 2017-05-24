#!/bin/sh -e
apt-get install -y python libexpat-dev \
	unixodbc-dev libssh2-1-dev libssl-dev libncurses5-dev
	
	
# Added below lines to install openjdk
echo 'deb http://deb.debian.org/debian jessie-backports main' \
      > /etc/apt/sources.list.d/jessie-backports.list
 
apt update -y

apt install --target-release jessie-backports \
      openjdk-8-jre-headless libssl-dev \
      ca-certificates-java \
      --assume-yes
## finish openjdk install 	
if [ ! -z $WITH_XML ]
then
	apt-get install -y xsltproc libxml2-utils fop
fi
apt-get -y clean
