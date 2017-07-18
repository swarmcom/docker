#!/bin/sh -e
COMMAND=${1:-"console"}
. erlang/activate
cd busytone
CFG=config
sed -i "s|agents@agents.ezuce|$AGENTS_NODE|g" $CFG/sys.config
sed -i "s|busytone@172.17.0.1|$NODE|g" $CFG/vm.args
sed -i "s|172.17.0.1|$REACH_HOST|g" $CFG/sys.config
exec _build/default/rel/busytone/bin/busytone $COMMAND $*
