FROM nginx:mainline-alpine
MAINTAINER Roman Galeev <jamhedd@gmail.com>

# override this (if needed) with run --env option
ENV NETWORK=reach3
ENV REACH=reach.$NETWORK
ENV REACH_WS=ws://$REACH:8937/ws

ADD reach-ui.tar /usr/share/nginx/html
COPY build/run.sh /root/run.sh

ENTRYPOINT /root/run.sh
