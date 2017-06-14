#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make oss_core && make sipXproxy
rm -rf ~/sipxecs
rm -rf ~/build
