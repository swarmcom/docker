#!/bin/sh -e
git clone --depth 1 --no-single-branch https://github.com/kamailio/kamailio src
cd src
git checkout -b 5.1 origin/5.1
