#!/bin/sh -e
if [ ! -z $SKIP_BUILD ]
then
	echo Skip repo clone and initial configuraion
	exit 0
fi

if [ ! -e ./sipxecs ]
then
	git clone --depth 1 $REPO ./sipxecs
fi

cd ~/sipxecs
autoreconf -if

mkdir -p ../build
cd ../build
../sipxecs/configure

