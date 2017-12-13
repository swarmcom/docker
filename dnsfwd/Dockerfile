FROM tklx/base:0.1.1
MAINTAINER Roman Galeev <jamhedd@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

USER root
WORKDIR "/root"


RUN apt-get -y update \
	&& apt-get -y install dnsmasq \
	&& apt-get -y clean \
	&& apt-clean --aggressive 

COPY dnsmasq.conf /etc/dnsmasq.conf

ENTRYPOINT ["/usr/sbin/dnsmasq", "-k"]
