#!/bin/sh -e
export SHM_MEMORY=64
export PKG_MEMORY=8
export USER=user
export GROUP=user

/usr/bin/epmd -daemon

CFG=etc/kamailio.cfg
INT_IP=`/sbin/ifconfig eth1 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`

sed -i "s|reach@reach.ezuce|$REACH_NODE|g" $CFG
sed -i "s|kamailio.ezuce|$NAME|g" $CFG
sed -i "s|external_ip|$EXT_IP|g" $CFG
sed -i "s|internal_ip|$INT_IP|g" $CFG

echo listen=udp:eth0:5060 advertise $EXT_IP:5060 > etc/kamailio-local.cfg
echo listen=udp:eth1:5080 >> etc/kamailio-local.cfg
echo alias=$EXT_IP >> etc/kamailio-local.cfg

exec kamailio/sbin/kamailio -E -DD \
	-f $CFG \
	-m $SHM_MEMORY -M $PKG_MEMORY -u $USER -g $GROUP
