FROM debian:jessie
MAINTAINER Roman Galeev <jamhedd@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none
ENV BASH_ENV .bashrc

USER root

COPY build/setup-os.sh build/setup-os.sh
RUN build/setup-os.sh
