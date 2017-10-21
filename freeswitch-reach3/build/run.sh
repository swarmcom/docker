#!/bin/sh -e
CFG=conf/autoload_configs

echo Setting FreeSWITCH Erlang node name to $NODE
xmlstarlet edit --inplace -u '/configuration/settings/param[@name="nodename"]/@value' -v "$NODE" $CFG/erlang_event.conf.xml
xmlstarlet edit --inplace -u '/configuration/settings/param[@name="shortname"]/@value' -v "false" $CFG/erlang_event.conf.xml

if [ -z ${REACH_HOST} ]
then
	echo "No REACH_HOST is set, deconfiguring xml_conf"
	rm -f $CFG/xml_curl_conf.xml
else
	echo Directing config requests to ReachMe node
	xmlstarlet edit --inplace -u '/configuration/bindings/binding/param[@name="gateway-url"]/@value' -v "$REACH_HOST/fsapi" $CFG/xml_curl_conf.xml
fi

echo Setting ReachMe Erlang node name to $REACH_NODE
xmlstarlet edit --inplace -u '/include/context/extension/condition/action[@application="erlang_sendmsg"]/@data' \
	-v "freeswitch_media_manager $REACH_NODE inivr $NODE \${uuid}" \
	conf/dialplan/reachme.xml

xmlstarlet edit --inplace -u '/include/context/extension/condition/action[@application="erlang"]/@data' \
	-v "freeswitch_media_manager:! $REACH_NODE" \
	conf/dialplan/reachme.xml

/usr/bin/epmd -daemon
exec /usr/local/freeswitch/bin/freeswitch -nf -np
