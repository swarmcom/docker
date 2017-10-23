#!/bin/sh -e
curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x kerl
while true; do echo "I'm alive" && sleep 1; done &
./kerl build 19.3 19.3
./kerl install 19.3 erlang/
. erlang/activate
git clone https://github.com/erlang/rebar3.git ./rebar
cd rebar && ./bootstrap && cp rebar3 ../
