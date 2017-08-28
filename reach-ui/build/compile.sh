#!/bin/sh -e
COMMIT=$(cat commit)
cd reach-ui
git fetch
git reset --hard $COMMIT
git clean -fd
sed -i "s|reach_ws:.*|reach_ws:\ \"$REACH_WS\"|" src/config.js
npm install
npm run build
npm install http-server
