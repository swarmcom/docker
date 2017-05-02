#!/bin/sh -e
cd ~
git clone --depth 1 git://github.com/sipXcom/sipxecs.git
cd sipxecs

autoreconf -if

mkdir ../build
cd ../build
../sipxecs/configure
