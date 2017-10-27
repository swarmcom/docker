#!/bin/sh -e
COMMIT=$(cat commit)
cd reach-ui
git fetch
git reset --hard $COMMIT
git clean -fd
yarn install
yarn run build
yarn add http-server
