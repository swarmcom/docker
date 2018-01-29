#!/bin/sh -e
git clone --no-single-branch https://github.com/kamailio/kamailio src
cd src
git checkout -b build 578e60227859eaead7828924c08d40ae62f6228d
