#!/bin/sh -e
. ~/erlang/activate

git clone $REPO rr && cd rr

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f

rebar3 get-deps
