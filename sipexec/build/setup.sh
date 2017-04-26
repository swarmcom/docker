#!/bin/sh -e
cd ~
git clone --depth 1 git://github.com/sipXcom/sipxecs.git
cd sipxecs
#git submodule init
#git submodule update
autoreconf -if

mkdir ../build
cd ../build
../sipxecs/configure
