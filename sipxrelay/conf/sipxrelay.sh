#!/bin/sh -e

JavaCmd=`/usr/local/sipx/bin/sipx-config --java`
TmpDir=/usr/local/sipx/var/sipxdata/tmp
LogDir=/usr/local/sipx/var/log/sipxpbx
ConfDir=/usr/local/sipx/etc/sipxpbx



Dependencies=`/usr/local/sipx/bin/java-dep -d /usr/local/sipx/share/java/sipXecs/sipXcommons Stun4J slf4j-api slf4j-log4j12 snmp4j commons-beanutils commons-collections commons-digester commons-logging dnsjava jain-sip-sdp javax.servlet jetty log4j sipxcommons ws-commons-util xmlrpc-client xmlrpc-server`
export CLASSPATH=`echo /usr/local/sipx/share/java/sipXecs/sipXbridge/*.jar ${Dependencies} | sed -e 's/ /:/g'`

$JavaCmd -Dprocname=sipxrelay \
  -Dconf.dir=${ConfDir} \
  -Dsipxrelay.command=start \
  -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.Log4JLogger \
   org.sipfoundry.sipxrelay.SymmitronServer \


/usr/bin/java -Dcom.ibm.tools.attach.enable=no -Dprocname=sipxrelay -Dconf.dir=/usr/local/sipx/etc/sipxpbx -Dsipxrelay.command=start -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.Log4JLogger org.sipfoundry.sipxrelay.SymmitronServer
