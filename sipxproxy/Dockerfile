FROM ezuce/siplibs
MAINTAINER Mihai Costache <costache.mircea.mihai@gmail.com>
USER root
COPY etc/sipxecx.repo /etc/yum.repos.d/


COPY src/sipxecs /root/sipxecs
COPY build/setup.sh build/setup.sh
RUN build/setup.sh
COPY build/build.sh build/build.sh
RUN build/build.sh
COPY src/sipxecs /root/sipxecs
COPY build/build.sh build/build.sh
RUN build/build.sh

COPY build/after-build.sh build/after-build.sh
RUN build/after-build.sh
COPY conf/mongo-client.ini /usr/local/sipx/etc/sipxpbx/
COPY conf/sipXproxy-config /usr/local/sipx/etc/sipxpbx/sipXproxy-config
COPY conf/resource-limits.ini /usr/local/sipx/etc/sipxpbx/resource-limits.ini
CMD ["/usr/local/sipx/bin/sipXproxy", "nofork"]
