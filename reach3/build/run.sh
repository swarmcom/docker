#!/bin/sh -e
COMMAND=${1:-"console"}
. erlang/activate
cd reach
exec _build/devel/rel/reach/bin/reach $COMMAND $*
