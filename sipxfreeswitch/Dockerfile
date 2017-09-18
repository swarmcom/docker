FROM centos

USER root

COPY build/build.sh build/build.sh
RUN build/build.sh

CMD freeswitch -nonat -conf /usr/local/sipx/etc/sipxpbx -db /usr/local/freeswitch/db -log /usr/local/freeswitch/log
