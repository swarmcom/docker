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


echo "Enter proxy IP address from your subdomain"
read proxyIP
PROXY_IP="$proxyIP"

echo "Enter registrar container IP address from your subdomain"
read regIP
REG_IP="$regIP"

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
export PROXY_IP
export DNS_IP
export REG_IP



cd ..
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml  up --force-recreate -d



sleep 55
#Mihai Fixing fallbackRules --  should be done from config

sudo sed -i "s/^\(SIPX_PROXY_HOST_NAME*:*\).*$/\1 \: $PROXY_HOST/"  ./sipxconfig/run/conf/1/sipXproxy-config
sudo sed -i "s/^\(SIPX_PROXY_BIND_IP*:*\).*$/\1 \: $PROXY_IP/"  ./sipxconfig/run/conf/1/sipXproxy-config
sudo sed -i "s/^\(SIPX_PROXY_HOSTPORT*:*\).*$/\1 \: $PROXY_IP:5060/"  ./sipxconfig/run/conf/1/sipXproxy-config
sudo sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $MACHINE_IP/"  ./sipxconfig/run/conf/1/sipXproxy-config
sudo sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $SIP_DOMAIN:5060/"  ./sipxconfig/run/conf/1/sipXproxy-config
sudo sed -i "s/^\(SIPX_PROXY_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  ./sipxconfig/run/conf/1/sipXproxy-config
sudo sed -i "s/^\(SIP_REGISTRAR_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  ./sipxconfig/run/conf/1/registrar-config


sudo sed -i "s/^\(SIP_REGISTRAR_BIND_IP*:*\).*$/\1 \: $REG_IP/"  ./sipxconfig/run/conf/1/registrar-config



docker-compose -f docker-compose-registrar.yml  up --force-recreate -d
