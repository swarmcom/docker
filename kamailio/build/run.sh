#!/bin/sh -e
export SHM_MEMORY=64
export PKG_MEMORY=8
export USER=user
export GROUP=user

/usr/bin/epmd -daemon

CFG=etc/kamailio.cfg
sed -i "s|reach@reach.ezuce|$REACH_NODE|g" $CFG
sed -i "s|kamailio.ezuce|$NAME|g" $CFG
sed -i "s|domain.ezuce|$SIP_DOMAIN|g" $CFG

echo listen=udp:eth0:5060 advertise $EXT_IP:5060 > etc/kamailio-local.cfg

exec kamailio/sbin/kamailio -E -DD \
	-f $CFG \
	-m $SHM_MEMORY -M $PKG_MEMORY -u $USER -g $GROUP
