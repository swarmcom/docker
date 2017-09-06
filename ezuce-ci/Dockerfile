FROM ezuce/erlang
MAINTAINER Roman Galeev <jamhedd@gmail.com>

ARG TOKEN
ARG DOCKER

# override on build with --build-arg option
ARG REPO=https://github.com/jamhed/ci
ARG BRANCH=master

USER root
COPY build/setup-docker.sh build/setup-docker.sh
RUN build/setup-docker.sh

USER user
WORKDIR /home/user
ENV HOME=$WORKDIR


COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY etc/commit commit
COPY build/compile.sh build/compile.sh
RUN build/compile.sh

COPY build/run.sh run.sh
COPY build/shell.sh shell.sh
ENTRYPOINT ./run.sh
