#!/usr/local/bin/python

import os
import socket
import subprocess

mongoHost = os.environ['MONGO_HOST']
domain = os.environ['DOMAIN']
sipDomain = os.environ['SIP_DOMAIN']
realm = os.environ['REALM']
fqdn = os.environ['HOST_NAME'] + '.' + domain
configuredIp = socket.gethostbyname(socket.gethostname())
primaryIp = configuredIp
primaryFqdn = fqdn
secret=subprocess.call("`head -c 18 /dev/urandom | base64`", shell=True)  


x = {'connectionUrl': 'mongodb://' + mongoHost + ':27017/?readPreference=nearest&readPreferenceTags=clusterId:1;readPreferenceTags=shardId:0;readPreferenceTags=', 'connectionString': 'sipxecs/' + mongoHost + ':27017', 'clusterId':'1', 'shardId':'0', 'useReadTags':'true', 'logappend':'true', 'port':'27017', 'replSet':'sipxecs', 'enable-driver-logging':'true', 'driver-log-level':'5', 'read-query-timeout-ms':'100', 'write-query-timeout-ms':'400'}

with open('mongo-client.ini', 'w') as f:
    for key, value in x.items():
        f.write('%s=%s\n' % (key, value))



y = {'sipxconfig.db.user':'postgres', 'coreContextImpl.debug':'false', 'sysdir.java':'/usr/local/sipx/share/java/sipXecs','sysdir.bin':'/usr/local/sipx/bin','sysdir.etc':'/usr/local/sipx/etc/sipxpbx','sysdir.var':'/usr/local/sipx/var/sipxdata','sysdir.log':'/usr/local/sipx/var/log/sipxpbx','sysdir.service':'/usr/local/sipx/etc/init.d','sysdir.share':'/usr/local/sipx/share/java/sipXecs','sysdir.thirdparty':'/usr/local/sipx/share/sipxecs','sysdir.share.root':'/usr/local/sipx/share','sysdir.phone':'/usr/local/sipx/var/sipxdata/configserver/phone','sysdir.tmp':'/usr/local/sipx/var/sipxdata/tmp','sysdir.version':'17.08','sysdir.build_number':'0000','sysdir.comment':'opendev','sysdir.user':'sipx','sysdir.doc':'/usr/local/sipx/share/www/doc','sysdir.www':'/usr/local/sipx/share/www','sysdir.mailstore':'/usr/local/sipx/var/sipxdata/mediaserver/data/mailstore','sysdir.vxml':'/usr/local/sipx/var/sipxdata/mediaserver/data','sysdir.vxml.prompts':'/usr/local/sipx/var/sipxdata/mediaserver/data/prompts','sysdir.vxml.scripts':'/usr/local/sipx/share/www/doc/aa_vxml','sysdir.libexec':'/usr/local/sipx/libexec/sipXecs','sysdir.default.firmware':'/usr/local/sipx/share/sipxecs/devicefiles','sysdir.vxml.moh':'/usr/local/sipx/var/sipxdata/mediaserver/data/moh','sysdir.webtest.srcdir':'/usr/local/sipx/sipxecs/sipXconfig/web/test','sysdir.mongo_client_ini':'/usr/local/sipx/etc/sipxpbx/mongo-client.ini','sysdir.src':'true','sysdir.libdir':'/usr/local/sipx/lib','openfire.home':'/opt/openfire','packageUpdateManager.yumCapable':'true','systemAudit':'true','hazelcastNotification':'true','password-policy':'blank','password-default':'','password-default-confirm':'','vmpin-default':'','vmpin-default-confirm':'','externalAliases.aliasAddins':'','mappingRules.externalRulesFileName':'','fallbackRules.externalRulesFileName':'','replicationManagerImpl.nThreads':'2','replicationManagerImpl.pageSize':'1000','replicationManagerImpl.useDynamicPageSize':'0','configManagerImpl.unregisteredConfigurable':'false','allow-subscription-to-self':'false','account-name':'false','email-address':'false','corsDomains':'','extAvatarSync':'false','sysdir.mongo_ns':'','domainManagerImpl.configuredDomain':domain,'domainManagerImpl.configuredSipDomain':sipDomain,'domainManagerImpl.configuredRealm':realm,'domainManagerImpl.configuredSecret':secret,'domainManagerImpl.configuredFqdn':fqdn,'domainManagerImpl.configuredIp':configuredIp,'locationsManagerImpl.primaryIp':primaryIp,'locationsManagerImpl.primaryFqdn':primaryFqdn,'mongoReplicaSetManager.primaryFqdn':primaryFqdn}

with open('sipxconfig.properties', 'w') as f:
    for key, value in y.items():
        f.write('%s=%s\n' % (key, value))

z = {'password':''}

with open('postgres-pwd.properties', 'w') as f:
    for key, value in z.items():
        f.write('%s=%s\n' % (key,value))
