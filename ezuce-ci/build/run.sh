#!/bin/sh -e
COMMAND=${1:-"console"}
. erlang/activate
cd ci
CFG=config
sed -i "s|ci@172.17.0.1|$NODE|g" $CFG/vm.args
mkdir -p $HOME/pr
export SHELL=/bin/bash
exec _build/default/rel/ci/bin/ci $COMMAND $*
