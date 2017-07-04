#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXregistry
rm -rf ~/sipxecs
rm -rf ~/build
