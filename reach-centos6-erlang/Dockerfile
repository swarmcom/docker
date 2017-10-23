FROM centos:6.6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on run with --env option
ENV NETWORK=ezuce

USER root
COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

USER user
WORKDIR /home/user
ENV PATH="${PATH}:/home/user:/home/user/node_modules/.bin"

COPY build/setup-erlang.sh build/setup-erlang.sh
RUN build/setup-erlang.sh

