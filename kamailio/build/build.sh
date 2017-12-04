#!/bin/sh -e
cd src
make PREFIX="/home/user/kamailio" include_modules="erlang dispatcher tls" cfg
make all
