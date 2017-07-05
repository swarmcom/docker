#!/bin/sh -e

PROCESS=`cat /usr/local/sipx/etc/sipxpbx/conf/1/$1.cfdat`
if [[ ${PROCESS:0:1} == "+" ]] ; then
  if [ ! "$(docker ps -q -f name=$1)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$1)" ]; then
        docker rm $1
    fi
    # run your container
    echo "starting $1"
    docker run -d --name $1 ezuce/$1
  fi
else
  if [ "$(docker ps -q -f name=$1)" ]; then
    echo "stopping $1"
    docker stop $1 && docker rm $1
  fi
fi
