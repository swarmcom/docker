#!/bin/sh -e
CFG=conf/autoload_configs

echo Setting FreeSWITCH Erlang node name to $NODE
xmlstarlet edit --inplace -u '/configuration/settings/param[@name="nodename"]/@value' -v "$NODE" $CFG/erlang_event.conf.xml
xmlstarlet edit --inplace -u '/configuration/settings/param[@name="shortname"]/@value' -v "false" $CFG/erlang_event.conf.xml

/usr/bin/epmd -daemon
exec /usr/local/freeswitch/bin/freeswitch -nf -np
