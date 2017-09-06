#!/bin/sh -e
COMMIT=$(cat commit)
cd reach-ui
git fetch
git reset --hard $COMMIT
git clean -fd
npm install
npm run build
npm install http-server
