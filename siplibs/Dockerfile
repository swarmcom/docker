FROM centos:6
MAINTAINER Mihai Costache <costache.mircea.mihai@gmail.com>

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

WORKDIR /home/user
