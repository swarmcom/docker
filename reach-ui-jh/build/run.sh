#!/bin/sh -e
cd reach-ui
if [ -n $REACH_WS ]
then
	sed -i "s|reach_ws:.*|reach_ws:\ \"$REACH_WS\",|" dist/config.js
else
	sed -i "s|reach_ws:.*|reach_ws:\ undefined,|" dist/config.js
fi

if [ -n $REACH_HTTP ]
then
	sed -i "s|reach_http:.*|reach_http:\ \"$REACH_HTTP\",|" dist/config.js
else
	sed -i "s|reach_http:.*|reach_http:\ undefined,|" dist/config.js
fi

if [ -n $REACH_RR ]
then
	sed -i "s|reach_rr:.*|reach_rr:\ \"$REACH_RR\",|" dist/config.js
else
	sed -i "s|reach_rr:.*|reach_rr:\ undefined,|" dist/config.js
fi

http-server ./
