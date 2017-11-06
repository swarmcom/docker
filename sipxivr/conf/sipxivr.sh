#!/bin/sh -e

JavaCmd=`/usr/local/sipx/bin/sipx-config --java`
TmpDir=/usr/local/sipx/var/sipxdata/tmp
LibDir=/usr/local/sipx/share/java/sipXecs/sipXivr
LogDir=/usr/local/sipx/var/log/sipxpbx

Dependencies=`/usr/bin/java-dep -d /usr/share/java/sipXecs/sipXcommons commons-codec commons-digester commons-beanutils commons-io commons-logging commons-lang dom4j iText jaudiotagger javamail javax.servlet jaxen jetty log4j mongo org.restlet sipxcommons slf4j-api slf4j-log4j12 cglib xmlrpc-common ws-commons-util commons-fileupload xmlrpc-client xmlrpc-server spring-beans org.springframework.web org.springframework.web.servlet spring-context spring-context-support spring-core org.springframework.jdbc org.springframework.transaction spring-expression spring-aop spring-data-commons spring-data-mongodb joda-time hazelcast-all`
export CLASSPATH=`echo /usr/local/sipx/etc/sipxpbx ${Dependencies} /usr/local/sipx/share/java/sipXecs/sipXconfig/plugins/*.jar | sed -e 's/ /:/g'`

/usr/bin/java -Dprocname=sipxivr -Dconf.dir=/usr/local/sipx/etc/sipxpbx -Dvar.dir=/usr/local/sipx/var/sipxdata -Dhazelcast.config=/usr/local/sipx/etc/sipxpbx/hz-config.xml -Djavax.net.ssl.trustStore=/usr/local/sipx/etc/sipxpbx/ssl/authorities.jks -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.keyStore=/usr/local/sipx/etc/sipxpbx/ssl/ssl.keystore -Djavax.net.ssl.keyStorePassword=changeit -Djetty.x509.algorithm=SunX509 -Djetty.ssl.password=changeit -Djetty.ssl.keypassword=changeit org.sipfoundry.sipxivr.SipXivrServer start 1
