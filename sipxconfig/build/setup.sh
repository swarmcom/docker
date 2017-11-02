#!/bin/sh -e
cd ~/sipxecs

autoreconf -if

mkdir ../build
cd ../build

echo '$(sipx_all)' > .modules-include

../sipxecs/configure
