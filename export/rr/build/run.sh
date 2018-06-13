#!/bin/bash
COMMAND=${1:-"console"}
CFG_ROOT=releases/1.0.2

cd rr
sed -i "s|rr@172.17.0.1|$NODE|g" $CFG_ROOT/vm.args
exec bin/rr $COMMAND $*
