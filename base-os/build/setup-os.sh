#!/bin/sh -e
apt-get -y update && apt-get -y upgrade

apt-get install -y make build-essential zip unzip git wget curl  openjdk-8-jdk
apt-get -y clean

useradd -s /bin/bash -m user

