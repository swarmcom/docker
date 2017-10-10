#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXportLib && make sipXcommons && make sipXrelay && make sipXbridge
rm -rf ~/sipxecs
