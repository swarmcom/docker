FROM tklx/base:0.1.1
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

USER root
WORKDIR "/root"

COPY etc/deps /root/deps
COPY etc/kamailio.cfg etc/inbound_routing.cfg etc/outbound_routing.cfg /home/user/etc/
ADD kamailio.tar /home/user

RUN groupadd user \
	&& useradd -g user user \
	&& apt-get -y update \
	&& apt-get -y install erlang-base net-tools $(cat /root/deps) \
	&& apt-get -y clean \
	&& apt-clean --aggressive 

RUN mkdir -p /var/run/kamailio && chown user:user /var/run/kamailio && chown -R user:user /home/user

ENV HOME "/home/user"
USER user
WORKDIR "/home/user"

ENTRYPOINT [ "./run.sh" ]
