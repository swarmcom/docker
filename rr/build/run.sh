#!/bin/sh -e
COMMAND=${1:-"console"}
. erlang/activate
cd rr
CFG=config
sed -i "s|rr@172.17.0.1|$NODE|g" $CFG/vm.args
exec _build/default/rel/rr/bin/rr $COMMAND $*
