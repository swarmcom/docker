FROM centos:6.6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on run with --env option
ENV NETWORK=ezuce
ENV NODE=reach@reach.$NETWORK
ENV MONGODB=mongodb.$NETWORK
ENV SIPXCOM=sipxcom.$NETWORK
ENV FSNODE=freeswitch@freeswitch.$NETWORK
ENV ELASTIC=elastic.$NETWORK

# override on build with --build-arg option
ARG REPO=git@github.com:ezuce/reach-app.git
ARG BRANCH=standalone

USER root
COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

USER user
WORKDIR /home/user
ENV PATH="${PATH}:/home/user:/home/user/node_modules/.bin"

COPY build/setup-erlang.sh build/setup-erlang.sh
RUN build/setup-erlang.sh

USER user
COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/compile-js.sh build/compile-js.sh
RUN build/compile-js.sh

COPY build/compile.sh build/compile.sh
RUN build/compile.sh

COPY build/run.sh run.sh
ENTRYPOINT ./run.sh
