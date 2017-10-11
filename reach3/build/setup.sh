#!/bin/sh -e
. ~/erlang/activate

git clone $REPO reach && cd reach

# avoid git complains
git config --global user.email "roman.galeev@ezuce.com"
git config --global user.name "Roman Galeev"

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f

rebar3 get-deps
