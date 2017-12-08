#FROM debian:jessie
FROM tklx/base:0.1.1
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override this (if needed) with run --env option
ENV NETWORK=ezuce
ENV NODE=reach@reach.$NETWORK
ENV FSNODE=freeswitch@freeswitch.$NETWORK
ENV KAMNODE=kamailio@kamailio.$NETWORK

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

COPY etc/deps /root/deps
ADD reach3.tar /home/user
COPY build/run.sh /home/user
RUN groupadd user \
	&& useradd -g user user \
	&& apt-get -y update \
	&& apt-get -y install $(cat /root/deps) \
	&& apt-clean --aggressive \
	&& chown user:user /home/user && chown user:user /home/user/run.sh

ENV PATH=$PATH:/home/user
USER user
WORKDIR "/home/user"
ENTRYPOINT [ "./run.sh" ]
