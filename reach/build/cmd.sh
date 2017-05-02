#!/bin/sh -e
COMMAND=${1:-"remote_console"}

cd reach && exec _rel/reach/bin/reach $COMMAND $*
