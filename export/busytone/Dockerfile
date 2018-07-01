#FROM debian:jessie
FROM tklx/base:0.1.1
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

# override on run with --env option
ENV NETWORK=ezuce
ENV NODE=busytone@busytone.$NETWORK
ENV AGENTS_NODE=agents@agents.$NETWORK

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

COPY etc/deps /root/deps
ADD busytone.tar /home/user
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
