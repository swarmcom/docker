FROM centos

USER root

COPY build/build.sh build/build.sh
RUN build/build.sh

ENTRYPOINT ["/usr/bin/freeswitch"]
