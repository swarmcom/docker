#!/bin/sh -e
yum install -y mod_ssl \
	net-snmp net-snmp-utils \
	python-pymongo python-argparse

rm -rf ~/build

# Removing sipxportlib - will be imported from siplibs
#rm -rf /usr/local/sipx/bin/sipx-config
#rm -rf /usr/local/sipx/bin/sipx-upgrade
#rm -rf /usr/local/sipx/share/doc/sipxportlib*
#rm -rf /usr/local/sipx/lib/libsipXport.so*

# Removing sipXcallLib - will be imported as above
#rm -rf /usr/local/sipx/lib/libsipXcall*

# Removing sipXtackLib
#rm -rf /usr/local/sipx/bin/dialogdisplay
#rm -rf /usr/local/sipx/bin/dialogwatch
#rm -rf /usr/local/sipx/bin/siptest
#rm -rf /usr/local/sipx/bin/subscribe-dialog-test
#rm -rf /usr/local/sipx/lib/libsipXtack*

#Removing sipXmediaLib & sipXmediaAdapterLib
#rm -rf /usr/local/sipx/lib/libsipXmedia*


#Removing sipXcommserverLib
#rm -rf /usr/local/sipx/bin/configmerge
#rm -rf /usr/local/sipx/bin/configquery
#rm -rf /usr/local/sipx/bin/pkg-upgrade
#rm -rf /usr/local/sipx/bin/sipx-backup
#rm -rf /usr/local/sipx/bin/sipx-remove-authorities-symlinks.sh
#rm -rf /usr/local/sipx/bin/sipx-remove-ssl-symlinks.sh
#rm -rf /usr/local/sipx/bin/sipx-restore
#rm -rf /usr/local/sipx/bin/sipx-snapshot
#rm -rf /usr/local/sipx/bin/sipx-ssl-symlinks.sh
#rm -rf /usr/local/sipx/bin/sipx-validate-xml
#rm -rf /usr/local/sipx/bin/xsdvalid
#rm -rf /usr/local/sipx/lib/libsipXcommserver*
#rm -rf /usr/local/sipx/libexec/sipXecs

#Removing sipXcommons
#rm -rf /usr/local/sipx/bin/java-dep
