#!/bin/sh -e
useradd -s /bin/bash -m user

apt-get -y update
apt-get -y upgrade

apt-get install -y --force-yes \
	vim curl wget git build-essential \
	freeswitch-video-deps-most \
	unixodbc-dev libssh2-1-dev libssl-dev libncurses5-dev \
	ladspa-sdk tap-plugins swh-plugins libgsm1 libfftw3-3 autotalent \
	librabbitmq-dev xmlstarlet

apt-get -y clean
