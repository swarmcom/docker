#!/bin/sh -e
apt-get install -y python libexpat-dev \
	unixodbc-dev libssh2-1-dev libssl-dev libncurses5-dev
	

if [ ! -z $WITH_XML ]
then
	apt-get install -y xsltproc libxml2-utils fop
fi
apt-get -y clean
