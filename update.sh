#!/bin/sh
export TOKEN=$(cat ~/TOKEN)
git pull origin master
./build.sh
./publish.sh
