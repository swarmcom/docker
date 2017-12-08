#!/bin/bash
COMMAND=${1:-"console"}
cd rr
CFG_ROOT=releases/1.0.1
SYS=$CFG_ROOT/sys.config

sed -i "s|rr@172.17.0.1|$NODE|g" $CFG/vm.args
exec bin/rr $COMMAND $*
