FROM ezuce/basecentos
MAINTAINER Mihai Costache <costache.mircea.mihai@gmail.com>

USER root
COPY etc/sipxecx.repo /etc/yum.repos.d/
RUN yum install -y openssl pcre boost poco-crypto poco-data  poco-foundation \
        poco-mysql  poco-net poco-netssl poco-odbc poco-pagecompiler poco-sqlite \
        poco-util poco-xml poco-zip pwdutils ruby bind-utils patch shadow-utils libodbc \
        unixODBC gperftools-libs xmlrpc-c-devel libmcrypt-devel libconfig gtest-devel \
        leveldb-devel hiredis-devel libpcap zeromq-devel mongo-cxx-driver v8-devel \
        && yum clean all && yum clean metadata




COPY tmp/sipx/ /usr/local/sipx/
CMD ["/usr/local/sipx/bin/sipregistrar", "nofork"]
