#!/bin/bash
COMMAND=${1:-"console"}
cd reach
CFG_ROOT=releases/3.0.0
SYS=$CFG_ROOT/sys.config
sed -i "s|freeswitch@freeswitch.ezuce|$FSNODE|g" $SYS
sed -i "s|kamailio@kamailio.ezuce|$KAMNODE|g" $SYS
sed -i "s|reach@172.17.0.1|$NODE|g" $CFG_ROOT/vm.args
exec bin/reach $COMMAND $*
