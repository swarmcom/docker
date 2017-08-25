#!/bin/sh
clear

# get host machine IP , Network, gateway

#Transform netmask to CIDR prefix function

mask2cdr ()
{
   # Assumes there's no "255." after a non-255 byte in the mask
   local x=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
   x=${1%%$3*}
   echo $(( $2 + (${#x}/4) ))
}
echo "Getting some host machine informations...wait a sec"
NETWORK_GATEWAY=$(ip route | grep "default" | awk '{print $3}')
MACHINE_IP=$(hostname -I | awk '{print $1}')
INTERFACE=$(route | grep "default" | awk '{print $8}')
NETWORK_IP=$(route | grep $INTERFACE | awk 'NR>1 {print $1}')
NETWORK_MASK=$(route | grep $INTERFACE | awk 'NR>1 {print $3}')
CIDR=$(mask2cdr $NETWORK_MASK)
FREEIPS=$(nmap -v -sn -n $NETWORK_IP/$CIDR -oG - | awk '/Status: Down/{print $2}')

echo "=================================================================="
echo "=== This procedure will remove all containers from this server ==="
echo "=================================================================="
printf "\n"
printf "\n"
printf "\n"

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

echo "Enter mongo host (fqdn)"
read mongoHost
MONGO_HOST="$mongoHost"

echo "Enter realm"
read realm
REALM="$realm"


# Create ezuce network
echo   "======================================================"
printf "=== Enter network subnet(CIDR): x.x.x.x/N.       === \n"
printf "=== Default is your host network $NETWORK_IP/$CIDR === \n"
echo   "======================================================"
read netSub

if [ -z "$netSub" ]
  then
    NETWORK_SUBNET="$NETWORK_IP/$CIDR"
  else
    NETWORK_SUBNET="$netSub"
fi

#cleanup

# Remove existing containers
if [ `docker ps -a | wc -l` > 0 ]
then
docker-compose down
docker stop `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker rm `docker ps -a | awk 'NR>1 {print $1}'` && \
       docker volume rm `docker volume ls | awk  'NR>1 {print $2}'`
fi

sudo rm -rf ../mongodb-sipxconfig/mongo-data/data/* && \
     sudo rm -rf ../sipxconfig/run && \
     sudo rm -rf ../dns/srv && \
     sudo rm -rf mongo-client.ini postgres-pwd.properties sipxconfig.properties && \
     sudo rm -rf ../mongodb-sipxconfig/mongo-data/data && \
     sudo rm -rf ../postgres-sipxconfig/pg-data/pgdata

clear
echo "=================================================================="
echo "=== Don't forget to make this net routable outside docker host ==="
echo "===      If you chosed NOT to use default host network         ==="
echo "=================================================================="


echo "Removing network ezuce...,if exists"
docker network rm ezuce
docker network create \
      -d macvlan \
      --subnet $NETWORK_SUBNET \
      --gateway $NETWORK_GATEWAY \
      -o parent=$INTERFACE \
       ezuce


printf "\n"
printf "\n"
echo "Enter DNS container IP address from your subdomain."
echo "Make sure IP is not already in use "
read dnsIP
DNS_IP="$dnsIP"



#Get docker ezuce network IP add
#NETADAPT=`docker network inspect ezuce | grep Id | awk -F ':' '{print $2}'`
#Removing "" from ezuce bridge network adapt name
#NETADAPT=${NETADAPT/\"/}
#NETADAPT=${NETADAPT/\"/}
#DROUTER_IP=$(ip addr show |grep  ${NETADAPT:0:8} | grep inet | awk '{print $2}' | awk -F "/" '{print $1}')


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
export FREEIPS

cd ..
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml  up --force-recreate -d

docker restart nginx
