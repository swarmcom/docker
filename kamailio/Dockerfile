FROM ezuce/erlang
MAINTAINER Roman Galeev <jamhedd@gmail.com>

USER root

COPY build/os.sh build/os.sh
RUN build/os.sh

USER user
WORKDIR /home/user

ENV PATH="${PATH}:/home/user"

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/build.sh build/build.sh
RUN build/build.sh

COPY build/install.sh build/install.sh
RUN build/install.sh

COPY etc/ etc

COPY build/run.sh ./run.sh

USER root
RUN mkdir -p /var/run/kamailio && chown user:user /var/run/kamailio && chown -R user:user etc
USER user

ENTRYPOINT ./run.sh
