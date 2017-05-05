FROM docker
MAINTAINER Roman Galeev <jamhedd@google.com>

ARG TOKEN
ARG DOCKER

RUN apk update && apk add --no-cache \
	bash procps coreutils grep curl jq findutils git
RUN delgroup $(getent group $DOCKER | cut -d: -f1) && addgroup -g $DOCKER docker && adduser -G docker -D -s /bin/bash user

USER user
WORKDIR /home/user

ENV HOME=$WORKDIR

RUN git clone https://$TOKEN@github.com/swarmcom/docker ./ezuce-docker

WORKDIR /home/user/ezuce-docker
