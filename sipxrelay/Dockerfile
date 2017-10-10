FROM ezuce/basecentos

USER root

COPY etc/sipxecx.repo /etc/yum.repos.d/
RUN yum install -y  java-1.7.0-openjdk-devel && yum clean all && yum clean metadata

COPY tmp/sipx/ /usr/local/sipx/
COPY conf/sipxrelay.sh /usr/local



RUN mkdir /var/log/sipx/
CMD /usr/local/sipxrelay.sh 2>&1 | tee -a /var/log/sipx/sipxrelay.log 
