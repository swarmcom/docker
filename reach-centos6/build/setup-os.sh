#!/bin/sh -e
adduser -d /home/user user
yum update -y

# erlang build-deps (except for xml docs)
yum install -y wget curl expat-devel unixODBC-devel libssh2-devel openssl-devel ncurses-devel gcc-c++ gcc make

# centos 6 git doesn't understand TOKEN
yum install -y http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm
yum install -y git

# node 6
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum install -y nodejs
