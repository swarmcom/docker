#!/bin/bash

proxyConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipXproxy-config"
registrarConfig="/usr/local/sipx/etc/sipxpbx/conf/1/registrar-config"
proxyIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxproxy"
registrarIpConfig="/usr/local/sipx/etc/sipxpbx/conf/1/sipxregistrar"
CFDAT_FILE_PROXY="/usr/local/sipx/etc/sipxpbx/conf/1/sipxproxy.cfdat"
CFDAT_FILE_REGISTRAR="/usr/local/sipx/etc/sipxpbx/conf/1/sipxregistrar.cfdat"

PROCESS_PROXY=`cat $CFDAT_FILE_PROXY`
PROCESS_REGISTRAR=`cat $CFDAT_FILE_REGISTRAR`

proxyIp=""
registrarIp=""

if [ -f "$proxyIpConfig" ]; then
    proxyIp=`cat $proxyIpConfig`
fi

if [ -f "$registrarIpConfig" ]; then
    registrarIp=`cat $registrarIpConfig`
fi

if [ -f "$proxyConfig" ] && [ -f "$registrarConfig" ] && [ -z "$registrarIp" ] && [ -z "$proxyIp" ] && [ ${PROCESS_PROXY:0:1} == "+" ] && [ ${PROCESS_REGISTRAR:0:1} == "+" ]; then
    cmd=`docker network inspect ezuce |grep IPv4 | awk -F":" '{print $2}'`
    result=$cmd
    set -f
    array=(${result//,/ })

    range=$(sed 's/.....$//' <<< $NETWORK_SUBNET)

    availableIps=()
    
    # 1 is resrved, so we will not take it into account
    for i in {2..256}
    do
       availableIps+=(${range}.${i})
    done

    for value in "${array[@]}"; do
        value=`echo $value | sed 's/.//;s/....$//'`
        availableIps=(${availableIps[@]//*$value*})
    done

    echo "Available IPs:"
    echo "${availableIps[@]}"
    echo "AvailableIps detected for registrar and proxy respectively:"
    echo "${availableIps[0]} and echo "${availableIps[1]}""

    sed -i "s/^\(SIPX_PROXY_HOST_NAME*:*\).*$/\1 \: sipxproxy.$SIP_DOMAIN/"  $proxyConfig
    sed -i "s/^\(SIPX_PROXY_BIND_IP*:*\).*$/\1 \: ${availableIps[1]}/"  $proxyConfig
    sed -i "s/^\(SIPX_PROXY_HOSTPORT*:*\).*$/\1 \: ${availableIps[1]}:5060/"  $proxyConfig
    sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $MACHINE_IP/"  $proxyConfig
    sed -i "s/^\(SIPX_PROXY_HOST_ALIASES*:*\).*$/& $SIP_DOMAIN:5060/"  $proxyConfig
    sed -i "s/^\(SIPX_PROXY_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  $proxyConfig
    sed -i "s/^\(SIP_REGISTRAR_LOG_LEVEL*:*\).*$/\1 \: DEBUG/"  $registrarConfig
    sed -i "s/^\(SIP_REGISTRAR_BIND_IP*:*\).*$/\1 \: ${availableIps[0]}/"  $registrarConfig
    echo "${availableIps[0]}" >> $registrarIpConfig
    echo "${availableIps[1]}" >> $proxyIpConfig
    cd /named
    /usr/bin/dns-config.sh --domain $SIP_DOMAIN --config-host $HOST_NAME --proxy-ip ${availableIps[1]} --registrar-ip ${availableIps[0]} --dns-ip $DNS_IP
    docker restart named
fi
