#!/bin/sh -e

cd ~/sipxecs

autoreconf -if

mkdir ../build
cd ../build
touch .modules-include
echo '$(sipx_all)' > .modules-include
../sipxecs/configure
