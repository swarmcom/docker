#!/bin/sh -e
CFG=conf/autoload_configs
echo Alter default fs configuration
rm -f conf/sip_profiles/external-ipv6.xml
rm -f conf/sip_profiles/internal-ipv6.xml
rm -rf conf/sip_profiles/external-ipv6

xmlstarlet edit --inplace -u '/configuration/settings/param[@name="listen-ip"]/@value' -v "0.0.0.0" $CFG/event_socket.conf.xml
xmlstarlet edit --inplace \
	-s '/configuration/modules' -t elem -n loadTMP -v "" \
	-i '/configuration/modules/loadTMP' -t attr -n module -v mod_erlang_event \
	-r //loadTMP -v load \
	$CFG/modules.conf.xml
