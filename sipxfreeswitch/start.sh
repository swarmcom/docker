#!/bin/bash

freeswitch -nc -nonat -conf /usr/local/sipx/etc/sipxpbx -db /usr/local/freeswitch/db -log /usr/local/freeswitch/log

dir=/usr/local/sipx/etc/sipxpbx/autoload_configs/
while inotifywait -qqe modify "$dir"; do
    fs_cli -x reloadxml
done
