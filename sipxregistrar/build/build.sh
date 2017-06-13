#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXportLib && make sipXcallLib && make sipXcommserverLib &&  make sipXcommons && make sipXregistry
rm -rf ~/sipxecs
