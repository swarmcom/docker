#FROM debian:jessie
FROM tklx/base:0.1.1
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override on run with --env option
ENV NETWORK=reach3
ENV NODE=rr@rr.$NETWORK

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

COPY etc/deps /root/deps
ADD rr.tar /home/user
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
