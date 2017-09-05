FROM debian:jessie
MAINTAINER Roman Galeev <jamhedd@gmail.com>

USER root

ARG REPO=https://freeswitch.org/stash/scm/fs/freeswitch.git
ARG CONFIG=master

COPY etc/freeswitch.list /etc/apt/sources.list.d/

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

COPY etc/commit commit

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/setup-commit.sh build/setup-commit.sh
RUN build/setup-commit.sh

COPY etc/modules.conf freeswitch/modules.conf
COPY build/configure.sh build/configure.sh
RUN build/configure.sh

COPY build/build.sh build/build.sh
RUN build/build.sh

COPY conf build/conf
COPY sounds build/sounds
COPY build/install.sh build/install.sh
RUN build/install.sh

USER freeswitch
WORKDIR "/usr/local/freeswitch"

COPY build/after-install.sh build/after-install.sh
RUN build/after-install.sh

COPY build/run.sh run.sh
ENTRYPOINT [ "./run.sh" ]

ENV NODE freeswitch@freeswitch.ezuce
ENV REACHME_NODE reachme@reachme.ezuce

EXPOSE 5060/udp
