#!/bin/sh -e
. ~/erlang/activate

git clone https://$TOKEN@github.com/swarmcom/docker ./docker

git clone $REPO ci && cd ci

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f

rebar3 get-deps
