FROM centos:6

COPY etc/sipxecx.repo /etc/yum.repos.d/

RUN yum install -y postgresql-server java-1.7.0-openjdk-devel mongodb-server && yum clean all && yum clean metadata

COPY tmp/sipx/ /usr/local/sipx/
COPY conf/sipxconfig.sh /usr/local

ENTRYPOINT ["/usr/local/sipxconfig.sh"]
