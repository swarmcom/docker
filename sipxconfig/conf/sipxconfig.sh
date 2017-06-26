#!/bin/sh -e

JavaCmd=`/usr/local/sipx/bin/sipx-config --java`
TmpDir=/usr/local/sipx/var/sipxdata/tmp
LibDir=/usr/local/sipx/share/java/sipXecs/sipXconfig
LogDir=/usr/local/sipx/var/log/sipxpbx

Dependencies=`/usr/local/sipx/bin/java-dep -d /usr/local/sipx/share/java/sipXecs/sipXcommons -d /usr/local/sipx/share/java/sipXecs/sipXconfig sipxconfig sipxconfig-web ant-contrib antlr aopalliance axis bcpkix-jdk15on bcprov-jdk15on cglib com.noelios.restlet com.noelios.restlet.ext.servlet commons-beanutils commons-codec commons-collections commons-digester commons-httpclient commons-io commons-lang commons-logging commons-net dom4j gdata-client gdata-contacts gdata-contacts guessencoding hibernate hibernate-commons-annotations hibernate-jpa jackson-core-asl jackson-mapper-asl jain-sip-sdp jakarta-oro jasper-runtime jasperreports javamail javax.servlet-api jaxen jaxrpc jettison joda-time js-1.7R4 ldapbp lucene-core lucene-analyzers-common lucene-queryparser lucene-suggest mime-dir-j-vcard4j mongo mysql-connector-java org.restlet org.restlet.ext.json org.restlet.ext.spring org.restlet.ext.fileupload spring-aop spring-beans spring-context spring-context-support spring-core spring-expression org.springframework.jdbc org.springframework.orm org.springframework.transaction spring-web spring-webmvc postgresql saxpath serializer sipxcommons slf4j-api slf4j-log4j12 snmp4j spring-data-commons spring-data-mongodb spring-ldap spring-ws thumbnailator velocity velocity-tools-generic xercesImpl xmlrpc xstream jedis spring-data-redis spring-security-config spring-security-core spring-security-ldap spring-security-web jradius-core jradius-dictionary gnu-crypto smack FastInfoset cxf-core cxf-rt-rs-service-description cxf-rt-transports-http cxf-rt-frontend-jaxrs cxf-rt-rs-extension-providers cxf-tools-wadlto-jaxrs javax.ws.rs-api neethi xmlschema-core wsdl4j jackson-jaxrs woodstox-core-asl jaxb-api jaxb-core jaxb-impl stax2-api jcl-over-slf4j spring-messaging jaudiotagger spring-websocket hazelcast-all reflections guava elasticsearch gson commons-cli ant ant-launcher backport-util-concurrent c3p0 cglib-nodep commons-fileupload commons-pool ez-vcard hivemind hivemind-lib jasper-compiler javassist jdom jetty-server jetty-util jetty-http jetty-xml jetty-servlet jetty-servlets jetty-security jetty-deploy jetty-io jetty-webapp websocket-api websocket-client websocket-common websocket-server websocket-servlet javax.servlet-api javax.servlet.jsp-api jta not-yet-commons-ssl ognl rome tapestry-annotations tapestry-contrib tapestry-framework xpp3 jackson-core jackson-databind jackson-annotations cdr-binding`
export CLASSPATH=`echo /usr/local/sipx/etc/sipxpbx ${Dependencies} /usr/local/sipx/share/java/sipXecs/sipXconfig/plugins/*.jar | sed -e 's/ /:/g'`

$JavaCmd -Dant.library.dir=${TmpDir} -Djava.net.preferIPv4Stack=true org.apache.tools.ant.launch.Launcher -emacs \
-quiet \
-Dlib.dir=${LibDir} \
-Dlog.dir=${LogDir} \
-Dtmp.dir=${TmpDir} \
-f /usr/local/sipx/etc/sipxpbx/database/database.xml \
upgrade

/usr/bin/java -Dcom.ibm.tools.attach.enable=no -Dprocname=sipxconfig -XX:MaxPermSize=128M -Xmx1024m -Djava.io.tmpdir=/usr/local/sipx/var/sipxdata/tmp -Djetty.lib.dir=/usr/local/sipx/share/java/sipXecs/sipXconfig -Djetty.conf.dir=/usr/local/sipx/etc/sipxpbx -Djetty.tmp.dir=/usr/local/sipx/var/sipxdata/tmp -Djetty.log.dir=/usr/local/sipx/var/log/sipxpbx -Dorg.apache.lucene.lockdir=/usr/local/sipx/var/sipxdata/tmp/index -Dorg.apache.commons.loging.Log=org.apache.commons.logging.impl.Log4JLogger -Dorg.eclipse.jetty.server.Request.maxFormKeys=2000 -Djava.awt.headless=true org.eclipse.jetty.xml.XmlConfiguration /usr/local/sipx/etc/sipxpbx/sipxconfig-jetty.xml
