#!/bin/bash

portRegistrar="-p 5070:5070 -p 5070:5070/udp"
portProxy="-p 5060:5060 -p 5060:5060/udp"
portCdr="-p 8130:8130 -p 8130:8130/udp"
portFreeswitch="-p 15060:15060 -p 15060:15060/udp -p 8084:8084 -p 8184:8184 -p 8284:8284 --expose=11000-12999/udp"
portRelay="-p 9090:9090/udp -p 8092:8092 -p 30000-30010:30000-30010/udp"
portBridge="-p 5080:5080 -p 5090:5090"
portProvision="-p 8185:8185 -p 8186:8186"

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxregistrar '$portRegistrar' ezuce-private; /usr/bin/process-watcher.sh sipxproxy '$portProxy' ezuce-private; /usr/bin/process-watcher.sh sipxcdr '$portCdr' ezuce-private; /usr/bin/process-watcher.sh sipxfreeswitch  '$portFreeswitch' ezuce-private; /usr/bin/process-watcher.sh sipxrelay  '$portRelay' ezuce-private; /usr/bin/process-watcher.sh sipxbridge '$portBridge' ezuce-private; /usr/bin/process-watcher.sh sipxprovision '$portProvision' ezuce-private"

exit
