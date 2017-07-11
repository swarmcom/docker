#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd /home/user/build/
make oss_core && make sipXproxy
