#!/bin/bash

params=( "$@" )
paramslength=${#params[@]}

for (( i=1; i<${paramslength}+1; i++ ));
do
  if [ "${params[$i-1]}" == "--domain" ]; then
   DOMAIN=${params[$i]}
   echo $DOMAIN
  elif [ "${params[$i-1]}" == "--config-host" ]; then
   CONFIG=${params[$i]}
   echo $CONFIG
  elif [ "${params[$i-1]}" == "--proxy-ip" ]; then
   PROXY=${params[$i]}
   echo $PROXY
  elif [ "${params[$i-1]}" == "--registrar-ip" ]; then
   REGISTRAR=${params[$i]}
   echo $REGISTRAR
  elif [ "${params[$i-1]}" == "--dns-ip" ]; then
   DNS=${params[$i]}
   echo $DNS
  fi
done


cat > var/${CONFIG}.${DOMAIN}.zone <<EOL
\$TTL 1800
@       IN     SOA    ns1.${CONFIG}.${DOMAIN}. root.${CONFIG}.${DOMAIN}. (
                       159001254 ; serial#
                       1800            ; refresh, seconds
                       1800            ; retry, seconds
                       1800            ; expire, seconds
                       1800 )          ; minimum TTL, seconds
${CONFIG}.${DOMAIN}.            NS    named

${CONFIG}.${DOMAIN}.       IN    NAPTR	    2 0 "s" "SIP+D2U" "" _sip._udp
${CONFIG}.${DOMAIN}.       IN    NAPTR	    2 0 "s" "SIP+D2T" "" _sip._tcp
EOL
  if [ "${PROXY}" != "" ]; then
    cat >> var/${CONFIG}.${DOMAIN}.zone <<EOL
_sip._tcp	  IN    SRV	30 10 5060 sipxproxy
_sip._udp	  IN    SRV	30 10 5060 sipxproxy
_sips._tcp	  IN    SRV	30 10 5061 sipxproxy
_sip._tls	  IN    SRV	30 10 5061 sipxproxy
EOL
  fi
  if [ "${REGISTRAR}" != "" ]; then
  cat >> var/${CONFIG}.${DOMAIN}.zone <<EOL
_sip._tcp.rr	  IN    SRV	30 10 5070 sipxregistrar
_sip._tcp.rr.sipxregistrar	  IN    SRV	10 10 5070 sipxregistrar
_sip._udp.rr     IN SRV         30 10 5070 sipxregistrar
EOL
  fi
  if [ "${PROXY}" != "" ]; then
    cat >> var/${CONFIG}.${DOMAIN}.zone <<EOL
sipxproxy 		IN    A	${PROXY}
EOL
  fi
  if [ "${REGISTRAR}" != "" ]; then
  cat >> var/${CONFIG}.${DOMAIN}.zone <<EOL
sipxregistrar 		IN    A	${REGISTRAR}
EOL
  fi
  if [ "${DNS}" != "" ]; then
  cat >> var/${CONFIG}.${DOMAIN}.zone <<EOL
named                   IN    A ${DNS}
EOL
  fi

cat > var/default.view.${DOMAIN}.zone <<EOL
\$TTL 1800
@       IN     SOA    ns1.${DOMAIN}. root.${DOMAIN}. (
                       159001254 ; serial#
                       1800            ; refresh, seconds
                       1800            ; retry, seconds
                       1800            ; expire, seconds
                       1800 )          ; minimum TTL, seconds
${DOMAIN}.            NS    named

${DOMAIN}.       IN    NAPTR	    2 0 "s" "SIP+D2U" "" _sip._udp
${DOMAIN}.       IN    NAPTR	    2 0 "s" "SIP+D2T" "" _sip._tcp
EOL
  if [ "${PROXY}" != "" ]; then
    cat >> var/default.view.${DOMAIN}.zone <<EOL
_sip._tcp	  IN    SRV	30 10 5060 sipxproxy
_sip._udp	  IN    SRV	30 10 5060 sipxproxy
_sips._tcp	  IN    SRV	30 10 5061 sipxproxy
_sip._tls	  IN    SRV	30 10 5061 sipxproxy
EOL
  fi
  if [ "${REGISTRAR}" != "" ]; then
    cat >> var/default.view.${DOMAIN}.zone <<EOL
_sip._tcp.rr	  IN    SRV	30 10 5070 sipxregistrar
_sip._tcp.rr.sipxregistrar	  IN    SRV	10 10 5070 sipxregistrar
_sip._tcp_rr.config               IN    SRV     10 10 5070 sipxregistrar
_sip._udp.rr.config               IN    SRV     10 10 5070 sipxregistrar
_sip._udp.rr     IN SRV         30 10 5070 sipxregistrar
EOL
fi
  if [ "${PROXY}" != "" ]; then
    cat >> var/default.view.${DOMAIN}.zone <<EOL
sipxproxy 		IN    A	${PROXY}
EOL
  fi
  if [ "${REGISTRAR}" != "" ]; then
  cat >> var/default.view.${DOMAIN}.zone <<EOL
sipxregistrar 		IN    A	${REGISTRAR}
EOL
  fi
  if [ "${DNS}" != "" ]; then
  cat >> var/default.view.${DOMAIN}.zone <<EOL
named                   IN    A ${DNS}
EOL
  fi

cat > etc/named.conf <<EOL
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
	listen-on port 53 { any; };

	directory 	"/named/var";
	dump-file 	"/named/var/data/cache_dump.db";
	statistics-file "/named/var/data/named_stats.txt";
	memstatistics-file "/named/var/data/named_mem_stats.txt";
        forwarders { 127.0.0.11; };

  allow-query     { 127.0.0.1; 172.16.0.0/12; $NETWORK_SUBNET;};
  allow-query-cache { 127.0.0.1; 172.16.0.0/12; $NETWORK_SUBNET; };
  allow-query-cache-on { 127.0.0.1; 172.16.0.0/12; $NETWORK_SUBNET; };

	/*
	 - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
	 - If you are building a RECURSIVE (caching) DNS server, you need to enable
	   recursion.
	 - If your recursive DNS server has a public IP address, you MUST enable access
	   control to limit queries to your legitimate users. Failing to do so will
	   cause your server to become part of large scale DNS amplification
	   attacks. Implementing BCP38 within your network would greatly
	   reduce such attack surface
	*/


	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key */
	bindkeys-file "/named/etc/named.iscdlv.key";

	managed-keys-directory "/named/var/dynamic";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel log_dns {
                file "/named/log/named.log" versions 3 size 10m;
                print-category yes;
                print-severity yes;
                print-time yes;
        };
        channel log_queries {
                file "/named/log/named_queries.log" versions 3 size 20m;
                print-category yes;
                print-severity yes;
                print-time yes;
        };
        category default { log_dns; };
        category queries { log_queries; };
        category lame-servers { null; };
        category edns-disabled { null; };
        category general { log_dns; };

        channel log_unmatched{
                file "/named/log/named_unmatched.log" versions 3 size 20m;
                severity info;
                print-severity yes;
                print-time yes;
                print-category yes;
        };

        category unmatched { log_unmatched; };
};

view default.view {

  zone "${DOMAIN}" IN {
    type master;
    file "default.view.${DOMAIN}.zone";
    allow-update { none; };
  };

  zone "${CONFIG}.${DOMAIN}" IN {
   type master;
   file "${CONFIG}.${DOMAIN}.zone";
   allow-update { none; };
 };

};
EOL
