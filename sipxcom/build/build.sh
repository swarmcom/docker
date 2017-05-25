#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipx
rm -rf ~/sipxecs
