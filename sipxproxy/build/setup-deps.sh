#!/bin/bash -e

# dart is required by sipXconfig, os rpm is broken
cd /opt
wget -q https://raw.githubusercontent.com/cjkao/dart-sdk-cent-os-6/master/dart-sdk.1.13.0-centos6.7-64.tar.gz
tar zxvf dart-sdk.1.13.0-centos6.7-64.tar.gz

# install all deps
yum install -y \
	git make automake libtool gcc-c++ \
	boost-devel cppunit-devel pcre-devel openssl-devel poco-devel gperftools-devel `# sipXportLib` \
	c-ares-devel db4-devel popt-devel `# resiprocate` \
	hiredis-devel leveldb-devel libconfig-devel v8-devel gtest-devel libtool-ltdl-devel libmcrypt-devel libpcap-devel xmlrpc-c-devel `# oss_core` \
	httpd-devel xerces-c-devel unixODBC-devel mongo-cxx-driver-devel `# sipXcommserverLib` \
	libev-devel zeromq-devel swig `# sipXsqa` \
	java-1.7.0-openjdk-devel `# sipXconfig` \
	libxslt \
	openfire `# sipXopenfire` \
	ruby ruby-dbi ruby-devel rubygem-net-sftp rubygems ruby-libs ruby-postgres  `# sipXcdr` \
	oss_core-devel oss_core 
