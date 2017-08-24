#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXcommons && make sipXcdr
rm -rf ~/sipxecs
