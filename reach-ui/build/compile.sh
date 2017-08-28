#!/bin/sh -e
COMMIT=$(cat commit)
cd reach-ui
git fetch
git reset --hard $COMMIT
git clean -fd
npm install http-server
npm install
npm run build
