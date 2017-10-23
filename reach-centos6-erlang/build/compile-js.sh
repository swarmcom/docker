#!/bin/sh -e
npm install -y grunt-cli
export PATH=$PATH:~/node_modules/.bin
cd reach && make site
