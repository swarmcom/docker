FROM centos:6

COPY etc/sipxecx.repo /etc/yum.repos.d/

RUN yum install -y postgresql-server java-1.7.0-openjdk-devel mongodb-server && yum clean all && yum clean metadata

COPY tmp/sipx/ /usr/local/sipx/
COPY conf/sipxconfig.sh /usr/local

ENTRYPOINT ["/usr/local/sipxconfig.sh"]
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
COPY conf/ssl-web.keystore /usr/local/sipx/etc/sipxpbx/ssl/
COPY conf/sipxconfig.sh sipxconfig.sh
ENTRYPOINT ["/home/user/sipxconfig.sh"]
