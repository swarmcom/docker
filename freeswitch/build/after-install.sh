#!/bin/sh -e
CFG=conf/autoload_configs
echo Alter FreeSWITCH configuration

xmlstarlet edit --inplace -u '/configuration/settings/param[@name="listen-ip"]/@value' -v "0.0.0.0" $CFG/event_socket.conf.xml


