FROM reach3/freeswitch
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

RUN rm -rf conf
COPY conf/ conf/

COPY build/run.sh run.sh
ENTRYPOINT [ "./run.sh" ]

USER root
RUN chown -R freeswitch:freeswitch /usr/local/freeswitch
USER freeswitch

ENV NODE agents@agents.ezuce
ENV BUSYTONE_NODE busytone@busytone.ezuce
ENV REACH_FREESWITCH freeswitch.ezuce
