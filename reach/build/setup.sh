#!/bin/sh -e
git clone $REPO reach

. erlang/activate

cd reach

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f

bin/rebar get-deps
