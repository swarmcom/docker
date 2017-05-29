FROM centos:6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on build with --build-arg option
ARG REPO=git://github.com/sipXcom/sipxecs.git
ARG SKIP_BUILD
ARG BRANCH
ARG UID
ARG GID

COPY etc/sipxecx.repo /etc/yum.repos.d/

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

COPY build/setup-deps.sh build/setup-deps.sh
RUN build/setup-deps.sh

RUN chown -R user:user /home/user

USER user
WORKDIR /home/user

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY build/build.sh build/build.sh
RUN build/build.sh

USER root

COPY build/after-build.sh build/after-build.sh
RUN build/after-build.sh

COPY build/fix-uid.sh build/fix-uid.sh
RUN build/fix-uid.sh

RUN chown -R user:user /home/user

USER user

COPY build/run.sh run.sh
ENTRYPOINT ./run.sh
