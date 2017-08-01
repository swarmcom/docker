#!/bin/sh -e
NETWORK=${NETWORK:-"ezuce"}

#Added paths in starting script
#sudo mkdir -p /srv/docker/bind9
#For Selinux enabled use below
#sudo chcon -Rt svirt_sandbox_file_t /srv/docker/bind9
sudo docker build -t $NETWORK/bind9 --rm .
