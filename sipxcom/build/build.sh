#!/bin/sh -e
if [ ! -z $SKIP_BUILD ]
then
	echo Skip building
	exit 0
fi

export SIPXPBXGROUP=user
export SIPXPBXUSER=user

cd ~/build/
make sipx
