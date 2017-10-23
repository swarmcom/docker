#!/bin/sh -e
curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x kerl
while true; do echo "I'm alive, travis, please don't boil me, `date`" && sleep 60; done &
./kerl build 19.3 19.3
./kerl install 19.3 erlang/
