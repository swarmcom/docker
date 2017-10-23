#!/bin/sh
. ~/erlang/activate

git clone $REPO reach && cd reach

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f

rebar3 get-deps
