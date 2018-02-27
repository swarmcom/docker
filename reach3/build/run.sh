#!/bin/sh -e
COMMAND=${1:-"console"}
. erlang/activate
cd reach
CFG_ROOT=config
sed -i "s|reach@172.17.0.1|$NODE|g" $CFG_ROOT/vm.args
sed -i "s|timescale.ezuce|timescale.$NETWORK|g" $CFG_ROOT/sys.config
exec _build/default/rel/reach/bin/reach $COMMAND $*
