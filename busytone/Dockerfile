FROM ezuce/erlang
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on run with --env option
ENV NETWORK=ezuce
ENV NODE=busytone@busytone.$NETWORK
ENV AGENTS_NODE=agents@agents.$NETWORK

# override on build with --build-arg option
ARG REPO=https://github.com/swarmcom/busytone.git
ARG BRANCH=master

USER user
WORKDIR /home/user

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY etc/commit commit
COPY build/compile.sh build/compile.sh
RUN build/compile.sh

COPY build/run.sh run.sh
COPY build/shell.sh shell.sh
COPY build/rpc.sh rpc.sh
COPY build/rpc.erl rpc.erl
ENTRYPOINT ./run.sh
