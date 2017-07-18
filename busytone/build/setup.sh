#!/bin/sh -e
. ~/erlang/activate

git clone $REPO busytone && cd busytone

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f

rebar3 get-deps
