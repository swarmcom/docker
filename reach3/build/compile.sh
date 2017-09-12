#!/bin/sh -e
. ~/erlang/activate
COMMIT=$(cat commit)
cd reach
git fetch
git reset --hard $COMMIT
git clean -fd
make devel
