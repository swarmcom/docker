#!/bin/sh -e
apt-get install -y python libexpat-dev \
	unixodbc-dev libssh2-1-dev libssl-dev libncurses5-dev
apt-get -y clean
