#!/bin/bash

CFDAT_FILE="/usr/local/sipx/etc/sipxpbx/conf/1/$1.cfdat"
IP_FILE="/usr/local/sipx/etc/sipxpbx/conf/1/$1"
IP=""
if [ -f "$IP_FILE" ]; then
    IP=`cat $IP_FILE`
fi
echo "Container $1 address file: $IP_FILE"
echo "Container $1 ip address: $IP"
echo "Host current directory used for mapping: $HOST_PWD"
echo "Mongo IP is $MONGO_IP"
echo "CDR IP is $CDR_IP"

if [ ! -z "$IP" ]; then
    PROCESS=`cat $CFDAT_FILE`
    if [[ ${PROCESS:0:1} == "+" ]] ; then
      if [ ! "$(docker ps -q -f name=$1)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=$1)" ]; then
            docker rm $1
        fi
        # run your container
        echo "starting $1"
        docker run --privileged -d --name $1 $2 --hostname $1.$SIP_DOMAIN --dns $DNS_IP -v $HOST_PWD/sipxconfig/run/conf/1:/usr/local/sipx/etc/sipxpbx -v $HOST_PWD/bootstrap/mongo-client.ini:/usr/local/sipx/etc/sipxpbx/mongo-client.ini --net $3 --ip="$IP" ezuce/$1
      fi
    else
      if [ "$(docker ps -q -f name=$1)" ]; then
        echo "stopping $1"
        docker stop $1 && docker rm $1
        sudo rm -rf $IP_FILE
      fi
    fi
fi