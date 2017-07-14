#!/bin/sh

echo "Enter domain"
read domain
DOMAIN="$domain"

echo "Enter sip domain"
read sipDomain
SIP_DOMAIN="$sipDomain"

echo "Enter host"
read host
HOST_NAME="$host"

echo "Enter mongo host"
read mongoHost
MONGO_HOST="$mongoHost"

echo "Enter realm"
read realm
REALM="$realm"

export MONGO_HOST
export DOMAIN
export SIP_DOMAIN
export HOST_NAME
export REALM

sudo rm -rf ../mongodb-sipxconfig/mongo-data/data/*

docker-compose down
docker-compose build
docker-compose up --force-recreate -d
