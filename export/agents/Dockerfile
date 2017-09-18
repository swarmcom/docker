FROM uniteme/freeswitch
MAINTAINER Roman Galeev <jamhedd@gmail.com>


#RUN rm -rf conf
COPY conf/ conf/

COPY build/run.sh run.sh
ENTRYPOINT [ "./run.sh" ]

USER root
RUN chown -R freeswitch:freeswitch /usr/local/freeswitch
USER freeswitch

ENV NODE agents@agents.ezuce
ENV BUSYTONE_NODE busytone@busytone.ezuce
ENV REACH_FREESWITCH freeswitch.ezuce
