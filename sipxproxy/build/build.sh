#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXportLib && make sipXtackLib && make sipXmediaLib && make sipXmediaAdapterLib && make sipXcallLib && make sipXcommserverLib &&  make sipXcommons && make sipXproxy
rm -rf ~/sipxecs
rm -rf ~/build
