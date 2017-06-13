FROM centos:6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

COPY etc/sipxecx.repo /etc/yum.repos.d/

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh


COPY build/setup-deps.sh build/setup-deps.sh
RUN build/setup-deps.sh

USER root


COPY src/sipxecs /home/user/sipxecs
RUN chown -R user:user /home/user/sipxecs

USER user

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/build.sh build/build.sh
RUN build/build.sh

USER root

COPY build/after-build.sh build/after-build.sh
RUN build/after-build.sh

WORKDIR /home/user
COPY conf/mongo-client.ini /usr/local/sipx/etc/sipxpbx/
COPY conf/sipXproxy-config /usr/local/sipx/etc/sipxpbx/sipXproxy-config
CMD ["/usr/local/sipx/usr/bin/sipXproxy", " --pid-file /var/run/sipxpbx/sipxproxy.pid"]
