FROM centos:6

USER root

COPY etc/sipxecx.repo /etc/yum.repos.d/
RUN yum install -y java-1.7.0-openjdk && yum clean all && yum clean metadata

COPY tmp/sipx/ /usr/local/sipx/
COPY conf/sipxconfig.sh /usr/local


ENTRYPOINT ["/usr/local/sipxconfig.sh"]
