FROM centos:6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

USER user
COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/build.sh build/build.sh
RUN build/build.sh
