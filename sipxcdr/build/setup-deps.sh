#!/bin/bash -e

# dart is required by sipXconfig, os rpm is broken
cd /opt
wget -q https://raw.githubusercontent.com/cjkao/dart-sdk-cent-os-6/master/dart-sdk.1.13.0-centos6.7-64.tar.gz
tar zxvf dart-sdk.1.13.0-centos6.7-64.tar.gz

# install all deps
yum install -y \
	git make automake libtool gcc-c++ \
	libxslt \
	unixODBC-devel \
	java-1.7.0-openjdk-devel ruby ruby-dbi ruby-devel rubygem-net-sftp rubygems ruby-libs ruby-postgres  `# sipXcdr`
