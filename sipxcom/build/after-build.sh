#!/bin/sh -e
yum install -y cfengine mod_ssl postgresql-server mongodb-server elasticsearch \
	vsftpd ntpd xinetd net-snmp net-snmp-utils \
	python-pymongo python-argparse
