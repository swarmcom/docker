#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXcommons && make sipXcdr && make sipXconfig
rm -rf ~/sipxecs
