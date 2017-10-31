#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXcommserverLib && make sipXportLib && make sipXsupervisor && make sipXcommons && make sipXcdr && make sipXconfig && make sipXprovision
rm -rf ~/sipxecs
