#!/bin/sh -e
yum clean all && yum clean metadata && \
yum install -y mod_ssl \
	net-snmp net-snmp-utils \
	python-pymongo python-argparse && \
yum clean all && yum clean metadata
rm -rf ~/build
