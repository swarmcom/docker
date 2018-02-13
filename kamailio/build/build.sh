#!/bin/bash -e
source ~/erlang/activate
cd src
make PREFIX="/home/user/kamailio" include_modules="erlang tls outbound path stun" cfg
make all
