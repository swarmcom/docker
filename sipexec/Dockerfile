FROM centos:6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

COPY etc/sipxecx.repo /etc/yum.repos.d/

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

COPY build/setup-deps.sh build/setup-deps.sh
RUN build/setup-deps.sh

USER user
COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/build.sh build/build.sh
RUN build/build.sh
