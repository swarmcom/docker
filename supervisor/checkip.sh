#!/bin/sh
if ping -c1 -w3 $1  >/dev/null 2>&1
 then
     FLAG="bad"
     echo "IP address allocated" >&2
 else
     echo "IP address either free " >&2
     FLAG="good"
fi
