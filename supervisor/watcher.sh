#!/bin/bash

portRegistrar="-p 5070:5070 -p 5070:5070/udp"
portProxy="-p 5060:5060 -p 5060:5060/udp"
portCdr="-p 8130:8130 -p 8130:8130/udp"
portIvr="-p 6701:6701 -p 8084:8084 -p 8085:8085 -p 8086:8086"
portFreeswitch="-p 15060:15060 -p 15060:15060/udp -p 8184:8184 -p 8284:8284 --expose=11000-12999/udp"

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxregistrar '$portRegistrar' ezuce-private; /usr/bin/process-watcher.sh sipxproxy '$portProxy' ezuce-public; /usr/bin/process-watcher.sh sipxcdr '$portCdr' ezuce-private; /usr/bin/process-watcher.sh sipxfreeswitch  '$portFreeswitch' ezuce-public; /usr/bin/process-watcher.sh sipxivr '$portIvr' ezuce-public"

exit
