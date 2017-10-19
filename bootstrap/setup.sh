#!/bin/sh
clear

if [ ! -f /etc/systemd/system/docker.service.d/docker.conf  ] ; then
    sudo ./beforesetup.sh
fi


echo "=================================================================="
echo "=== This procedure will remove all containers from this server ==="
echo "=================================================================="
printf "\n\n\n"


echo "=================================================================="
echo "=== If you agree press Y, if not setup will exit and you CAN'T ==="
echo "===              install this application                      ==="
echo "=================================================================="

read readAnswer

ANSWER="$readAnswer"

if [ "$ANSWER" != "Y" ] && [ "$ANSWER" != "y" ]
  then
    exit 1
fi


echo "Enter domain"
read domain
DOMAIN="$domain"

echo "Enter sip domain"
read sipDomain
SIP_DOMAIN="$sipDomain"

echo "Enter config hostname (without domain)"
read host
HOST_NAME="$host"

echo "Enter mongo host (without domain)"
read mongoHost
MONGO_HOST="$mongoHost"

echo "Enter realm"
read realm
REALM="$realm"

clear
echo "Will do some cleanup first.Please wait..."
#cleanup

# Remove existing containers
if [ `docker ps -a | wc -l` > 0 ]
then
docker-compose down > /dev/null 2>&1
docker stop `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker rm `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker volume rm `docker volume ls | awk  'NR>1 {print $2}'`
fi

sudo rm -rf ../mongodb-sipxconfig/mongo-data/data/* && \
     sudo rm -rf ../sipxconfig/run && \
     sudo rm -rf ../dns/srv && \
     sudo rm -rf mongo-client.ini postgres-pwd.properties sipxconfig.properties && \
     sudo rm -rf ../mongodb-sipxconfig/mongo-data/data && \
     sudo rm -rf ../postgres-sipxconfig/pg-data/pgdata && \
     sudo rm -rf ../postgres-sipxcdr/data/pgdata


. ./create-docker-networks.sh

printf "\n"
printf "\n"
#echo "Enter DNS container IP address from your public subdomain."
#echo "Make sure IP is not already in use "
#read dnsIP
#DNS_IP="$dnsIP"
MONGO_IP="172.18.0.100"
CDR_IP="172.18.0.101"
DNS_IP="172.18.0.102"


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
export DROUTER_IP
#export FREEIPS
export PRIVATE_SUBNET
export MONGO_IP
export CDR_IP

cd ..
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml  up --force-recreate -d

docker restart nginx

#docker create --name sipxconfigcopy ezuce/sipxconfig
#docker cp sipxconfigcopy:/usr/local/sipx/share/www/ sipxconfig/run
#docker rm sipxconfigcopy
