#!/bin/sh -e
git clone $REPO reach-ui && cd reach-ui

git fetch origin $BRANCH:build_branch
git checkout build_branch
git clean -d -f
