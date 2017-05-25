#!/bin/sh -e
cd ~/sipxecs

autoreconf -if

mkdir ../build
cd ../build
../sipxecs/configure
