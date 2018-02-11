#!/bin/sh -e
apt-get update
apt-get install -y gcc flex bison libssl-dev libcurl4-openssl-dev libxml2-dev libpcre3-dev pkg-config
apt-get -y clean
