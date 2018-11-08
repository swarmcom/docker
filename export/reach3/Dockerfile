FROM tklx/base:0.1.1
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

# override this (if needed) with run --env option
ENV NETWORK=ezuce
ENV NODE=reach@reach.$NETWORK
ENV FSNODE=freeswitch@freeswitch.$NETWORK
ENV KAMNODE=kamailio@kamailio.$NETWORK

ENV DEBIAN_FRONTEND noninteractive
ENV APT_LISTCHANGES_FRONTEND=none
ENV RELX_REPLACE_OS_VARS=true

COPY etc/deps /root/deps
ADD reach3.tar /home/user
COPY build/run.sh /home/user
COPY build/rpc.sh /home/user
COPY build/rpc.erl /home/user

RUN groupadd user \
	&& useradd -g user user \
	&& apt-get -y update \
	&& apt-get -y install $(cat /root/deps) \
	&& apt-clean --aggressive \
	&& chown user:user /home/user && chown user:user /home/user/run.sh

ENV PATH=$PATH:/home/user
USER user
WORKDIR "/home/user"
RUN mkdir "reach/db-mnesia"
ENTRYPOINT [ "./run.sh" ]
