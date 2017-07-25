#!/bin/sh -e
yum update -y
yum install -y wget vim && yum clean all && yum clean metadata

useradd -s /bin/bash -m user

mkdir -p /usr/local/sipx && chown user:user -R /usr/local/sipx

export SIPXPBXGROUP=user
export SIPXPBXUSER=user
