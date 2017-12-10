FROM tklx/base:0.1.1
MAINTAINER Roman Galeev <jamhedd@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

USER root
WORKDIR "/root"

RUN apt-get -y update \
	&& apt-get -y install socat \
	&& apt-get -y clean \
	&& apt-clean --aggressive 

ENTRYPOINT [ "socat", "UDP4-RECVFROM:53,fork", "UDP4-SENDTO:127.0.0.11:53" ]
