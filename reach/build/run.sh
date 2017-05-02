#!/bin/sh -e
COMMAND=${1:-"console"}
cd reach && exec _rel/reach/bin/reach $COMMAND $*
