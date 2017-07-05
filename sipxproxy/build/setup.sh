#!/bin/sh -e
cd /home/user/sipxecs

autoreconf -if

mkdir -p ../build
cd ../build
/home/user/sipxecs/configure
