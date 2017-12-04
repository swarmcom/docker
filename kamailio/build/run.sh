#!/bin/sh -e
export SHM_MEMORY=64
export PKG_MEMORY=8
export USER=user
export GROUP=user

/usr/bin/epmd -daemon

exec kamailio/sbin/kamailio -E -DD \
	-f etc/kamailio.cfg \
	-m $SHM_MEMORY -M $PKG_MEMORY -u $USER -g $GROUP
