#!/bin/bash

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxregistrar 5070; /usr/bin/process-watcher.sh sipxproxy 5060"

exit
