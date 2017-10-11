#!/bin/sh -e
xmlstarlet edit --inplace -u '/include/profile/settings/param[@name="ext-sip-ip"]/@value' -v "$EXT_IP" conf/sip_profiles/external.xml
xmlstarlet edit --inplace -u '/include/profile/settings/param[@name="ext-rtp-ip"]/@value' -v "$EXT_IP" conf/sip_profiles/external.xml
exec /usr/local/freeswitch/bin/freeswitch -nf -np
