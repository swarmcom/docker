FROM centos:6
MAINTAINER Roman Galeev <jamhedd@gmail.com>
USER root
COPY etc/sipxecx.repo /etc/yum.repos.d/
COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh
COPY build/setup-deps.sh build/setup-deps.sh
RUN build/setup-deps.sh
COPY src/sipxecs /root/sipxecs
COPY build/setup.sh build/setup.sh
RUN build/setup.sh

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
