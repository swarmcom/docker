#!/bin/sh

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

HOST_IP=$(hostname -I | awk '{print $1}')
NETWORK_GATEWAY=$(ip route | grep "default" | awk 'NR==1 {print $3}')
MACHINE_IP=$(hostname -I | awk '{print $1}')
INTERFACE=$(route | grep "default" | awk 'NR==1 {print $8}')
NETWORK_IP=$(route | grep $INTERFACE | awk 'NR==2 {print $1}')
NETWORK_MASK=$(route | grep $INTERFACE | awk 'NR==2 {print $3}')
CIDR=$(mask2cdr $NETWORK_MASK)
clear
echo 'Getting free IPs in the public subnet range...It will take a while'
FREEIPS=$(nmap -v -sn -n $NETWORK_IP/$CIDR -oG - | awk '/Status: Down/{print $2}')


# Create ezuce-public network

echo   "==========================================================="
printf "===   ezuce-public network subnet(CIDR): x.x.x.x/N.     === \n"
printf "===                 will use your                       === \n"
printf "===   DEFAULT host network $NETWORK_IP/$CIDR            === \n"
echo   "==========================================================="

## improved detection on network subnet"
NETWORK_SUBNET="$(ip route | grep $INTERFACE | grep $HOST_IP | awk '{print $1}')"


clear

printf "Removing ezuce-* networks if exists\n"   

if [ `docker network ls | grep ezuce | wc -l` > 0 ]
  then
    docker network rm ezuce > /dev/null 2>&1
    docker network rm ezuce-private > /dev/null 2>&1
    docker network rm ezuce-public > /dev/null 2>&1
fi

#Preparing host to macvaln intercommunication
sudo ip link del ezuce-macvlan link $INTERFACE type macvlan mode bridge > /dev/null 2>&1
printf "\nProvide IP x.x.x.x/N address for your virtual Host interface. Should be a free IP from host public subnet\n"
read virtIP
VIRT_IP="$virtIP"



sudo ip link add ezuce-macvlan link $INTERFACE type macvlan mode bridge
sudo ip addr add $VIRT_IP dev ezuce-macvlan
sudo ifconfig ezuce-macvlan up


docker network create \
      -d macvlan \
      --subnet $NETWORK_SUBNET \
      --gateway $HOST_IP \
      -o parent=$INTERFACE \
       ezuce-public > /dev/null 2>&1


#     - create a private ezuce-private (bridge mode for all except proxy freeswitch and sipxbridge)
#     - rename above above ezuce network to ezuce-public (macvlan for all exposed containers)

# Create ezuce-private network


PRIVATE_SUBNET='172.18.0.0/16'
docker network create \
       --subnet $PRIVATE_SUBNET \
       ezuce-private > /dev/null 2>&1

export PRIVATE_SUBNET
