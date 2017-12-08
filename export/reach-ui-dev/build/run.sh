#!/bin/sh -e
cd /usr/share/nginx/html
if [ -n $REACH_WS ]
then
	sed -i "s|reach_ws:.*|reach_ws:\ \"$REACH_WS\",|" ./config.js
else
	sed -i "s|reach_ws:.*|reach_ws:\ undefined,|" ./config.js
fi

if [ -n $REACH_HTTP ]
then
	sed -i "s|reach_http:.*|reach_http:\ \"$REACH_HTTP\",|" ./config.js
else
	sed -i "s|reach_http:.*|reach_http:\ undefined,|" ./config.js
fi

if [ -n $REACH_RR ]
then
	sed -i "s|reach_rr:.*|reach_rr:\ \"$REACH_RR\",|" ./config.js
else
	sed -i "s|reach_rr:.*|reach_rr:\ undefined,|" ./config.js
fi

exec /usr/sbin/nginx -g "daemon off;"
