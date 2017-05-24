#!/bin/sh -e
cd ~




curl -O -k https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x kerl
./kerl update releases
./kerl build 19.3 19.3
./kerl install 19.3 erlang
. erlang/activate
./kerl cleanup all
