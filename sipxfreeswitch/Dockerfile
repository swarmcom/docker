FROM centos

USER root

COPY build/build.sh build/build.sh
RUN build/build.sh
EXPOSE 15060 8084 8184 8284 11000-12999

CMD freeswitch -nonat -conf /usr/local/sipx/etc/sipxpbx -db /usr/local/freeswitch/db -log /usr/local/freeswitch/log
