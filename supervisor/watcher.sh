#!/bin/sh -e

watch -n 2 '/usr/bin/process-watcher.sh sipxproxy; /usr/bin/process-watcher.sh sipxregistrar'
exit
