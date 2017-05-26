#!/bin/sh -e
yum install -y cfengine mod_ssl \
	vsftpd ntpd xinetd net-snmp net-snmp-utils \
	python-pymongo python-argparse
