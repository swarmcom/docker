#!/bin/sh -e
CFG=conf/autoload_configs

echo Setting FreeSWITCH Erlang node name to $NODE
xmlstarlet edit --inplace -u '/configuration/settings/param[@name="nodename"]/@value' -v "$NODE" $CFG/erlang_event.conf.xml
xmlstarlet edit --inplace -u '/configuration/settings/param[@name="shortname"]/@value' -v "false" $CFG/erlang_event.conf.xml

echo Setting ReachMe Erlang node name to $REACHME_NODE

xmlstarlet edit --inplace -u '/include/context/extension/condition/action[@application="erlang_sendmsg"]/@data' \
	-v "freeswitch_media_manager $REACHME_NODE inivr \${uuid}" \
	conf/dialplan/reachme.xml

xmlstarlet edit --inplace -u '/include/context/extension/condition/action[@application="erlang"]/@data' \
	-v "freeswitch_media_manager:! $REACHME_NODE" \
	conf/dialplan/reachme.xml

/usr/bin/epmd -daemon
exec /usr/local/freeswitch/bin/freeswitch -nf -np
