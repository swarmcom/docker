#!/bin/bash

watch -n 2 "/usr/bin/file-watcher.sh; /usr/bin/process-watcher.sh sipxproxy; /usr/bin/process-watcher.sh sipxregistrar"

exit
