#!/bin/sh -e
cd reach-ui
sed -i "s|reach_ws:.*|reach_ws:\ \"$REACH_WS\"|" src/config.js
node_modules/.bin/http-server ./
