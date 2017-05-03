#!/bin/sh -e
COMMAND=${1:-"console"}
cd reach
ROOT=_rel/reach/releases/2.0
CFG=$ROOT/sys.config
sed -i "s|freeswitch@freeswitch.ezuce|$FSNODE|g" $CFG
sed -i "s|mongodb.ezuce|$MONGODB|g" $CFG
sed -i "s|redis.ezuce|$REDIS|g" $CFG
sed -i "s|sipxcom.ezuce|$SIPXCOM|g" $CFG
sed -i "s|reach@127.0.0.1|$NODE|g" $ROOT/vm.args
exec _rel/reach/bin/reach $COMMAND $*
