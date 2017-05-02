#!/bin/sh -e
apt-get install -y npm
ln -s /usr/bin/nodejs /usr/bin/node
npm install -g grunt-cli
