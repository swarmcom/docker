#!/bin/bash

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxregistrar 5070 ezuce-private; /usr/bin/process-watcher.sh sipxproxy 5060 ezuce-public; /usr/bin/process-watcher.sh sipxcdr 8130 ezuce-private"

exit
