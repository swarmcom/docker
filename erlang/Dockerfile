FROM ezuce/base
MAINTAINER Roman Galeev <jamhedd@gmail.com>

COPY build/os.sh build/os.sh
RUN build/os.sh

USER user
WORKDIR /home/user
ENV PATH="${PATH}:/home/user"

COPY build/erlang.sh build/erlang.sh
RUN build/erlang.sh

COPY build/rebar3.sh build/rebar3.sh
RUN build/rebar3.sh

COPY build/env.sh build/env.sh
RUN build/env.sh

