#!/bin/bash

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxregistrar; /usr/bin/process-watcher.sh sipxproxy"

exit
