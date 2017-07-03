FROM ezuce/siplibs
MAINTAINER Mihai Costache <costache.mircea.mihai@gmail.com>

COPY etc/sipxecx.repo /etc/yum.repos.d/
COPY src/sipxecs /home/user/sipxecs
RUN chown -R user:user /home/user/sipxecs

USER user


COPY build/build.sh build/build.sh
RUN build/build.sh

USER root

COPY build/after-build.sh build/after-build.sh
RUN build/after-build.sh

WORKDIR /home/user
COPY conf/mongo-client.ini /usr/local/sipx/etc/sipxpbx/
COPY conf/sipXproxy-config /usr/local/sipx/etc/sipxpbx/sipXproxy-config
COPY conf/resource-limits.ini /usr/local/sipx/etc/sipxpbx/resource-limits.ini
CMD ["/usr/local/sipx/bin/sipXproxy", "nofork"]
