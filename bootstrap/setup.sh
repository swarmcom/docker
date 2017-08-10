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


echo "Create a routable network"
#echo "Enter network name"
#read netName
#NETWORK_NAME="$netName"

echo "Enter network subnet(CIDR): x.x.x.x/N"
read netSub
NETWORK_SUBNET="$netSub"

#cleanup
docker stop `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker rm `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker volume rm `docker volume ls | awk  'NR>1 {print $2}'`

sudo rm -rf ../mongodb-sipxconfig/mongo-data/data/* && \
     sudo rm -rf ../sipxconfig/run

echo "=================================================================="
echo "=== Don't forget to make this net routable outside docker host ==="
echo "=================================================================="



echo "Removing network ezuce...,if exists"
docker network rm ezuce
sleep 2
docker network create \
      --subnet $NETWORK_SUBNET \
       ezuce


#echo "Enter proxy IP address from your subdomain"
#read proxyIP
#PROXY_IP="$proxyIP"

#echo "Enter registrar container IP address from your subdomain"
#read regIP
#REG_IP="$regIP"

echo "Enter dns container IP address from your subdomain"
read dnsIP
DNS_IP="$dnsIP"

#Get host IP ADD
MACHINE_IP=$(hostname -I | awk '{print $1}')


export MONGO_HOST
export DOMAIN
export SIP_DOMAIN
export HOST_NAME
export REALM
export REGISTRAR_HOST
export PROXY_HOST
export MACHINE_IP
export NETWORK_NAME
export NETWORK_SUBNET
export DNS_IP


cd ..
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml  up --force-recreate -d

docker run -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker
