#!/bin/bash

machineIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/machine"
machineIp=""
if [ -f "$machineIpConfig" ]; then
    machineIp=`cat $machineIpConfig`
fi

if [ -z "$machineIp" ]; then
    echo "$MACHINE_IP" >> $machineIpConfig
fi

proxyConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipXproxy-config"
registrarConfig="/usr/local/sipx/etc/sipxpbx/conf/1/registrar-config"
cdrConfig="/usr/local/sipx/etc/sipxpbx/conf/1/callresolver-config"
proxyIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxproxy"
natConfig="/usr/local/sipx/etc/sipxpbx/conf/1/nattraversalrules.xml"
bridgeConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxbridge.xml"

freeswitchConfig="/usr/local/sipx/etc/sipxpbx/conf/1/freeswitch.xml"
registrarIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxregistrar"
cdrIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxcdr"
freeswitchIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxfreeswitch"
natIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxrelay"
bridgeIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxbridge"

CFDAT_FILE_PROXY="/usr/local/sipx/etc/sipxpbx/conf/1/sipxproxy.cfdat"
CFDAT_FILE_REGISTRAR="/usr/local/sipx/etc/sipxpbx/conf/1/sipxregistrar.cfdat"
CFDAT_FILE_SIPXCDR="/usr/local/sipx/etc/sipxpbx/conf/1/sipxcdr.cfdat"
CFDAT_FILE_SIPXFREESWITCH="/usr/local/sipx/etc/sipxpbx/conf/1/sipxfreeswitch.cfdat"
CFDAT_FILE_RELAY="/usr/local/sipx/etc/sipxpbx/conf/1/sipxrelay.cfdat"
CFDAT_FILE_BRIDGE="/usr/local/sipx/etc/sipxpbx/conf/1/sipxbridge.cfdat"

PROCESS_PROXY=`cat $CFDAT_FILE_PROXY`
PROCESS_REGISTRAR=`cat $CFDAT_FILE_REGISTRAR`
PROCESS_CDR=`cat $CFDAT_FILE_SIPXCDR`
PROCESS_FREESWITCH=`cat $CFDAT_FILE_SIPXFREESWITCH`
PROCESS_RELAY=`cat $CFDAT_FILE_RELAY`
PROCESS_BRIDGE=`cat $CFDAT_FILE_BRIDGE`

proxyIp=""
registrarIp=""
cdrIp=""
freeswitchIp=""
natIp=""
bridgeIp=""

if [ -f "$proxyIpConfig" ]; then
    proxyIp=`cat $proxyIpConfig`
fi
if [ -f "$registrarIpConfig" ]; then
    registrarIp=`cat $registrarIpConfig`
fi
if [ -f "$cdrIpConfig" ]; then
    cdrIp=`cat $cdrIpConfig`
fi
if [ -f "$freeswitchIpConfig" ]; then
   freeswitchIp=`cat $freeswitchIpConfig`
fi
if [ -f "$natIpConfig" ]; then
   natIp=`cat $natIpConfig`
fi

if [ -f "$bridgeIpConfig" ]; then
   bridgeIp=`cat $bridgeIpConfig`
fi

if { { [ -f "$registrarConfig" ] && [ -z "$registrarIp" ] && [ ${PROCESS_REGISTRAR:0:1} == "+" ]; } || { [ -f "$proxyConfig" ] && [ -z "$proxyIp" ] && [ ${PROCESS_PROXY:0:1} == "+" ]; } || { [ -f "$cdrConfig" ] && [ -z "$cdrIp" ] && [ ${PROCESS_CDR:0:1} == "+" ]; } || { [ -f "$freeswitchConfig" ] && [ -z "$freeswitchIp" ] && [ ${PROCESS_FREESWITCH:0:1} == "+" ]; } || { [ -f "$natConfig" ] && [ -z "$natIp" ] && [ ${PROCESS_RELAY:0:1} == "+" ]; } || { [ -f "$bridgeConfig" ] && [ -z "$bridgeIp" ] && [ ${PROCESS_BRIDGE:0:1} == "+" ]; }; }; then
#  FREE PRIVATE SUBNET IPs for registrar
     cmd=`docker network inspect ezuce-private |grep IPv4 | awk -F":" '{print $2}'`
     result=$cmd
     set -f
     PRIVATE_SUBNET=`docker network inspect ezuce-private | grep Subnet | awk -F":" '{print $2}' |  sed -e 's/"//g' -e 's/,//g'`
     usedArray=(${result//,/ })
     rangePrivate=`/usr/bin/newcidr.sh $PRIVATE_SUBNET `
     rangeArrayPrivate=(${rangePrivate//,/})
     for value in "${usedArray[@]}"; do
            value=`echo $value | sed 's/.//;s/....$//'`
            rangeArrayPrivate=(${rangeArrayPrivate[@]//*$value*})
     done

     echo "Available private IP detected for registrar"
     echo "${rangeArrayPrivate[2]}"
     echo "Available private IP detected for proxy"
     echo "${rangeArrayPrivate[3]}"

     if [ -z "$proxyIp" ] && [ ${PROCESS_PROXY:0:1} == "+" ]; then
         sed -i "s/^\(SIPX_PROXY_HOST_NAME*:*\).*$/\1 \: sipxproxy.$SIP_DOMAIN/"  $proxyConfig
         sed -i "s/^\(SIPX_PROXY_BIND_IP*:*\).*$/\1 \: ${rangeArrayPrivate[3]}/"  $proxyConfig
         sed -i "s/^\(SIPX_PROXY_HOSTPORT*:*\).*$/\1 \: ${rangeArrayPrivate[3]}:5060/"  $proxyConfig
         sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $MACHINE_IP/"  $proxyConfig
         sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $SIP_DOMAIN:5060/"  $proxyConfig
         sed -i "s/^\(SIPX_PROXY_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  $proxyConfig

         echo "${rangeArrayPrivate[3]}" >> $proxyIpConfig
     fi
     if [ -z "$registrarIp" ] && [ ${PROCESS_REGISTRAR:0:1} == "+" ]; then
         sed -i "s/^\(SIP_REGISTRAR_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  $registrarConfig
         sed -i "s/^\(SIP_REGISTRAR_BIND_IP*:*\).*$/\1 \: ${rangeArrayPrivate[2]}/"  $registrarConfig
         echo "${rangeArrayPrivate[2]}" >> $registrarIpConfig
     fi
#     sed -i "s/\(<proxyunsecurehostport>\)\([^<]*\)\(<[^>]*\)/\1$MACHINE_IP:5060\3/g"  $natConfig
#    sed -i "s/\(<mediarelaynativeaddress>\)\([^<]*\)\(<[^>]*\)/\1$MACHINE_IP\3/g"  $natConfig
    if [ -z "$cdrIp" ] && [ ${PROCESS_CDR:0:1} == "+" ]; then
        echo "${rangeArrayPrivate[4]}" >> $cdrIpConfig
    fi
    if [ -z "$freeswitchIp" ] && [ ${PROCESS_FREESWITCH:0:1} == "+" ]; then
    #  for freeswitchIp in "${rangeArrayPublic[@]:3}"; do
    #        . /usr/bin/checkip.sh $freeswitchIp
    #         if [ $FLAG="good" ]; then
               freeswitchIp="${rangeArrayPrivate[5]}"
               echo "Available public IPs detected for freeswitch :"
               echo "${freeswitchIp}"
    #           break 2
    #        fi
    #  done
        echo "${freeswitchIp}" >> $freeswitchIpConfig
    fi
    if [ -z "$natIp" ] && [ ${PROCESS_RELAY:0:1} == "+" ]; then
        echo "${rangeArrayPrivate[6]}" >> $natIpConfig
    fi
    if [ -z "$bridgeIp" ] && [ ${PROCESS_BRIDGE:0:1} == "+" ]; then
        echo "${rangeArrayPrivate[7]}" >> $bridgeIpConfig
    fi

    cd /named
    /usr/bin/dns-config.sh --domain $SIP_DOMAIN --config-host $HOST_NAME --proxy-ip ${rangeArrayPrivate[3]} --registrar-ip ${rangeArrayPrivate[2]} --dns-ip $DNS_IP --mongo-ip $MONGO_IP --cdr-ip ${rangeArrayPrivate[4]} --fs-ip ${freeswitchIp} --nat-ip ${rangeArrayPrivate[6]}
    docker restart named
fi



#sed -i "s|<mediarelaynativeaddress>[0-9a-z.]\{1,\}</mediarelaynativeaddress>|<mediarelaynativeaddress>$bridgeIP</mediarelaynativeaddress>|g" $natConfig
#sed -i "s|<proxyunsecurehostport>[0-9a-z.]\{1,\}:5060</proxyunsecurehostport>|<proxyunsecurehostport>$proxyIP</proxyunsecurehostport>|g" $natConfig
#sed -i "s|<proxysecurehostport>[0-9a-z.]\{1,\}:5060</proxysecurehostport>|<proxysecurehostport>$proxyIP</proxysecurehostport>|g" $natConfig
