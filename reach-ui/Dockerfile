FROM node:9.2.0
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on run with --env option
ENV NETWORK=ezuce
ENV REACH=reach.$NETWORK
ENV REACH_WS=ws://$REACH:8937/ws

# override on build with --build-arg option
ARG REPO=https://github.com/swarmcom/reach-ui.git
ARG BRANCH=master
ARG COMMIT=HEAD

RUN useradd -s /bin/bash -m user && npm install -g http-server

USER user
WORKDIR /home/user

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY etc/commit commit
COPY build/compile.sh build/compile.sh
RUN build/compile.sh

COPY build/setup-globals.sh build/setup-globals.sh
RUN build/setup-globals.sh

COPY build/run.sh run.sh
ENTRYPOINT ./run.sh

EXPOSE 8080
