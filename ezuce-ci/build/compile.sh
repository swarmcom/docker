#!/bin/sh -e
. ~/erlang/activate
COMMIT=$(cat commit)
cd ci
git fetch
git reset --hard $COMMIT
git clean -fd
make
