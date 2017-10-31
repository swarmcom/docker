FROM ezuce/basecentos

USER root

COPY etc/sipxecx.repo /etc/yum.repos.d/
RUN yum install -y java-1.7.0-openjdk-devel && yum clean all && yum clean metadata

COPY tmp/sipx/ /usr/local/sipx/

ENTRYPOINT ["/usr/local/sipx/bin/sipxprovision.sh"]
