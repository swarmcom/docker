FROM ezuce/siplibs
MAINTAINER Mihai Costache <costache.mircea.mihai@gmail.com>
USER root

COPY etc/sipxecx.repo /etc/yum.repos.d/
COPY src/sipxecs /root/sipxecs
COPY build/build.sh build/build.sh
RUN build/build.sh
COPY build/after-build.sh build/after-build.sh
RUN build/after-build.sh


WORKDIR /home/user
COPY conf/sipxregistrar.properties /usr/local/sipx/etc/sipxpbx/sipxregistrar/
COPY conf/mongo-client.ini /usr/local/sipx/etc/sipxpbx/
COPY conf/registrar-config /usr/local/sipx/etc/sipxpbx/registrar-config
COPY conf/resource-limits.ini /usr/local/sipx/etc/sipxpbx/resource-limits.ini
CMD ["/usr/local/sipx/bin/sipregistrar"]
