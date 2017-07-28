#!/bin/sh

echo "Enter domain"
read domain
DOMAIN="$domain"

echo "Enter sip domain"
read sipDomain
SIP_DOMAIN="$sipDomain"

echo "Enter config hostname (without domain)"
read host
HOST_NAME="$host"

echo "Enter mongo host (fqdn)"
read mongoHost
MONGO_HOST="$mongoHost"

echo "Enter realm"
read realm
REALM="$realm"

echo "Enter registrar host (fqdn)"
read registrarHost
REGISTRAR_HOST="$registrarHost"

echo "Enter proxy host (fqdn)"
read proxyHost
PROXY_HOST="$proxyHost"

export MONGO_HOST
export DOMAIN
export SIP_DOMAIN
export HOST_NAME
export REALM
export REGISTRAR_HOST
export PROXY_HOST

#cleanup
docker stop `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker rm `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker volume rm `docker volume ls | awk  'NR>1 {print $2}'`

sudo rm -rf ../mongodb-sipxconfig/mongo-data/data/* && \
     sudo rm -rf ../sipxconfig/run

cd ..
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml  up --force-recreate -d

sleep 45

docker-compose -f docker-compose-registrar.yml  up --force-recreate -d
