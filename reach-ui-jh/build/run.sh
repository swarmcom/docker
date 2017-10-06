#!/bin/sh -e
cd reach-ui
if [ -n $REACH_WS ]
then
	sed -i "s|reach_ws:.*|reach_ws:\ \"$REACH_WS\"|" dist/config.js
else
	sed -i "s|reach_ws:.*|reach_ws:\ undefined|" dist/config.js
fi
node_modules/.bin/http-server ./
