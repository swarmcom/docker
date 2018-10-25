FROM ezuce/erlang
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

# override on run with --env option
ENV NETWORK=ezuce
ENV NODE=rr@rr.$NETWORK

# override on build with --build-arg option
ARG REPO=https://github.com/ezuce/rr
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
ENTRYPOINT ./run.sh
