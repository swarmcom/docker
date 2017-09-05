#!/bin/bash

proxyConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipXproxy-config"
registrarConfig="/usr/local/sipx/etc/sipxpbx/conf/1/registrar-config"
cdrConfig="/usr/local/sipx/etc/sipxpbx/conf/1/callresolver-config"
proxyIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxproxy"
natConfig="/usr/local/sipx/etc/sipxpbx/conf/1/nattraversalrules.xml"
registrarIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxregistrar"
cdrIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxcdr"
CFDAT_FILE_PROXY="/usr/local/sipx/etc/sipxpbx/conf/1/sipxproxy.cfdat"
CFDAT_FILE_REGISTRAR="/usr/local/sipx/etc/sipxpbx/conf/1/sipxregistrar.cfdat"
CFDAT_FILE_SIPXCDR="/usr/local/sipx/etc/sipxpbx/conf/1/sipxcdr.cfdat"

PROCESS_PROXY=`cat $CFDAT_FILE_PROXY`
PROCESS_REGISTRAR=`cat $CFDAT_FILE_REGISTRAR`
PROCESS_CDR=`cat $CFDAT_FILE_SIPXCDR`

proxyIp=""
registrarIp=""
cdrIp=""

if [ -f "$proxyIpConfig" ]; then
    proxyIp=`cat $proxyIpConfig`
fi

if [ -f "$registrarIpConfig" ]; then
    registrarIp=`cat $registrarIpConfig`
fi

if [ -f "$cdrIpConfig" ]; then
    cdrIp=`cat $cdrIpConfig`
fi

if [ -f "$proxyConfig" ] && [ -f "$registrarConfig" ] && [ -f "$cdrConfig" ] && [ -z "$registrarIp" ] && [ -z "$proxyIp" ] && [ -z "$cdrIp" ] && [ ${PROCESS_PROXY:0:1} == "+" ] && [ ${PROCESS_REGISTRAR:0:1} == "+" ] && [ ${PROCESS_CDR:0:1} == "+" ]; then
  FREE PRIVATE SUBNET IPs for registrar
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


#FREE PUBLIC SUBNET IPs for proxy

    rangePublic=$FREEIPS
    rangeArrayPublic=(${rangePublic//,/})
    rangeArrayPublic=${rangeArrayPublic[@]}
#

     echo "Available public IPs:"
     echo "${rangeArrayPublic[@]}"
     echo "Available public Ips detected for proxy :"
     echo "${rangeArrayPublic[2]}"
     echo "Available private IPs:"
      echo "${rangeArrayPrivate[@]}"
     echo "Available private IPs detected for registrar"
     echo "${rangeArrayPrivate[2]}"

     sed -i "s/^\(SIPX_PROXY_HOST_NAME*:*\).*$/\1 \: sipxproxy.$SIP_DOMAIN/"  $proxyConfig
     sed -i "s/^\(SIPX_PROXY_BIND_IP*:*\).*$/\1 \: ${rangeArrayPublic[2]}/"  $proxyConfig
     sed -i "s/^\(SIPX_PROXY_HOSTPORT*:*\).*$/\1 \: ${rangeArrayPublic[2]}:5060/"  $proxyConfig
     sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $MACHINE_IP/"  $proxyConfig
     sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $SIP_DOMAIN:5060/"  $proxyConfig
     sed -i "s/^\(SIPX_PROXY_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  $proxyConfig
     sed -i "s/^\(SIP_REGISTRAR_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  $registrarConfig
     sed -i "s/^\(SIP_REGISTRAR_BIND_IP*:*\).*$/\1 \: ${rangeArrayPrivate[2]}/"  $registrarConfig
#     sed -i "s/\(<proxyunsecurehostport>\)\([^<]*\)\(<[^>]*\)/\1$MACHINE_IP:5060\3/g"  $natConfig
#    sed -i "s/\(<mediarelaynativeaddress>\)\([^<]*\)\(<[^>]*\)/\1$MACHINE_IP\3/g"  $natConfig

    echo "${rangeArrayPrivate[2]}" >> $registrarIpConfig
    echo "${rangeArrayPublic[2]}" >> $proxyIpConfig
    echo "${rangeArrayPrivate[3]}" >> $cdrIpConfig
    cd /named
    /usr/bin/dns-config.sh --domain $SIP_DOMAIN --config-host $HOST_NAME --proxy-ip ${rangeArrayPublic[2]} --registrar-ip ${rangeArrayPrivate[2]} --dns-ip $DNS_IP --mongo-ip $MONGO_IP
    docker restart named
fi
