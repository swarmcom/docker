FROM ezuce/base
MAINTAINER Roman Galeev <jamhedd@gmail.com>

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

USER user

COPY build/setup-erlang.sh build/setup-erlang.sh
RUN build/setup-erlang.sh
