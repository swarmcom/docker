#!/bin/sh -e

JavaCmd=`/usr/local/sipx/bin/sipx-config --java`

Dependencies=`/usr/local/sipx/bin/java-dep -d /usr/local/sipx/share/java/sipXecs/sipXcommons sipxcommons log4j commons-codec commons-collections commons-lang commons-io commons-logging javax.servlet velocity jetty`
export CLASSPATH=`echo /usr/local/sipx/etc/sipxpbx ${Dependencies} /usr/local/sipx/share/java/sipXecs/sipXprovision/*.jar | sed -e 's/ /:/g'`

StorePassword="changeit"

Command="$JavaCmd \
    $TrustStoreOpts \
    $KeyStoreOpts \
    ${SIPXPROVISION_OPTS} \
    -Djetty.x509.algorithm=$X509Algorithm \
    -Djetty.ssl.password=$StorePassword \
    -Djetty.ssl.keypassword=$StorePassword \
    -Dconf.dir=/usr/local/sipx/etc/sipxpbx \
    -Dvar.dir=/usr/local/sipx/var/sipxdata \
    org.sipfoundry.sipxprovision.SipXprovision \
    $Args"

runuser -c "${Command}"
