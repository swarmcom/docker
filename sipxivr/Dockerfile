FROM ezuce/basecentos

USER root

COPY etc/sipxecx.repo /etc/yum.repos.d/
RUN yum install -y postgresql-server java-1.7.0-openjdk-devel mongodb-server && yum clean all && yum clean metadata

COPY tmp/sipx/ /usr/local/sipx/
COPY conf/sipxivr.sh /usr/local
#COPY conf/ssl-web.keystore /usr/local/sipx/etc/sipxpbx/ssl/


ENTRYPOINT ["/usr/local/sipxivr.sh"]
