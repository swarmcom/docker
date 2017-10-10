#!/bin/bash -e


# install all deps
yum install -y \
	git make automake libtool gcc-c++ \
	boost-devel cppunit-devel pcre-devel openssl-devel poco-devel gperftools-devel `# sipXportLib` \
	c-ares-devel db4-devel popt-devel `# resiprocate` \
	hiredis-devel leveldb-devel libconfig-devel v8-devel gtest-devel libtool-ltdl-devel libmcrypt-devel libpcap-devel xmlrpc-c-devel `# oss_core` \
	httpd-devel xerces-c-devel   \
	libev-devel  swig `# sipXsqa` \
	java-1.7.0-openjdk-devel `# sipXconfig` \
	libxslt \
	
