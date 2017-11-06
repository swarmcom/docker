#!/bin/sh -e
export SIPXPBXGROUP=user
export SIPXPBXUSER=user
cd ~/build/
make sipXcommserverLib && make sipXportLib && make sipXsupervisor && make sipXcommons && make sipXivr
rm -rf ~/sipxecs
