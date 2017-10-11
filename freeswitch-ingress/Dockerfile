FROM ezuce/freeswitch
MAINTAINER Roman Galeev <jamhedd@gmail.com>

RUN rm -rf conf
COPY conf/ conf/

COPY build/run.sh run.sh
ENTRYPOINT [ "./run.sh" ]

USER root
RUN chown -R freeswitch:freeswitch /usr/local/freeswitch
USER freeswitch
