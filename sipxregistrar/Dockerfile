FROM centos:6
MAINTAINER Mihai Costache <costache.mircea.mihai@gmail.com>


COPY etc/sipxecx.repo /etc/yum.repos.d/
RUN yum install -y openssl pcre boost poco-crypto poco-data  poco-foundation \
        poco-mysql  poco-net poco-netssl poco-odbc poco-pagecompiler poco-sqlite \
        poco-util poco-xml poco-zip pwdutils ruby bind-utils patch shadow-utils libodbc \
        unixODBC gperftools-libs xmlrpc-c-devel libmcrypt-devel libconfig gtest-devel \
        leveldb-devel hiredis-devel libpcap zeromq-devel mongo-cxx-driver v8-devel \
        && yum clean all && yum clean metadata


COPY tmp/sipx/ /usr/local/sipx/



###Needed conf files to start registrar
#COPY conf/sipxregistrar.properties /usr/local/sipx/etc/sipxpbx/sipxregistrar/
#COPY conf/mongo-client.ini /usr/local/sipx/etc/sipxpbx/
#COPY conf/registrar-config /usr/local/sipx/etc/sipxpbx/registrar-config
#COPY conf/resource-limits.ini /usr/local/sipx/etc/sipxpbx/resource-limits.ini

CMD ["/usr/local/sipx/bin/sipregistrar"]
