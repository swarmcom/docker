#!/bin/bash

portRegistrar="-p 5070:5070 -p 5070:5070/udp"
portProxy="-p 5060:5060 -p 5060:5060/udp"
portCdr="-p 8130:8130 -p 8130:8130/udp"
portFreeswitch="-p 15060:15060 -p 15060:15060/udp -p 8084:8084 -p 8184:8184 -p 8284:8284 -p 11000-11010:11000-11010/udp -p 11000-11010:11000-11010/tcp"

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxregistrar '$portRegistrar' ezuce-private; /usr/bin/process-watcher.sh sipxproxy '$portProxy' ezuce-public; /usr/bin/process-watcher.sh sipxcdr '$portCdr' ezuce-private; /usr/bin/process-watcher.sh sipxfreeswitch  '$portFreeswitch' ezuce-private"

exit
