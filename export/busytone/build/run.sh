#!/bin/bash
COMMAND=${1:-"console"}
cd busytone
CFG_ROOT=releases/1.0.0
SYS=$CFG_ROOT/sys.config

sed -i "s|agents@agents.ezuce|$AGENTS_NODE|g" $CFG/sys.config
sed -i "s|busytone@172.17.0.1|$NODE|g" $CFG/vm.args
sed -i "s|172.17.0.1|$REACH_HOST|g" $CFG/sys.config
exec bin/busytone $COMMAND $*
