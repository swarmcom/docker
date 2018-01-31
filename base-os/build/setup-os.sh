#!/bin/sh -e
apt-get -y update && apt-get -y upgrade

apt-get install -y make build-essential zip unzip git wget curl net-tools tcpdump bind9-host apt-utils vim
apt-get -y clean

useradd -s /bin/bash -m user

