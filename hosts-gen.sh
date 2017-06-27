#!/bin/sh -e
./hosts.sh > /etc/docker_hosts
cat /etc/docker_hosts
sudo /etc/init.d/dnsmasq restart
