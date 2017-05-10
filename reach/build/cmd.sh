#!/bin/sh -e
COMMAND=${1:-"remote_console"}
cd reach && exec _build/default/rel/reach/bin/reach $COMMAND $*
