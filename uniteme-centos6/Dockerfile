FROM centos:6.6
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on run with --env option
ENV NETWORK=ezuce

COPY etc/openuc.repo /etc/yum.repos.d/openuc.repo
COPY etc/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo

USER root
COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh

COPY build/download-all.sh build/download-all.sh
RUN build/download-all.sh

COPY build/setup.sh build/setup.sh
RUN build/setup.sh

COPY etc/cfg cfg

COPY build/run.sh run.sh
ENTRYPOINT ["/sbin/init", "2"]
