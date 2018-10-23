FROM nginx:mainline-alpine
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

# override this (if needed) with run --env option
ENV NETWORK=reach3
ENV REACH=reach.$NETWORK
ENV REACH_WS=ws://$REACH:8937/ws

RUN rm -r /etc/nginx/conf.d/default.conf
RUN rm -f /usr/share/nginx/html/index.html

ADD reach-ui.tar /usr/share/nginx/html
COPY build/default.conf /etc/nginx/conf.d/default.conf
COPY build/run.sh /root/run.sh

ENTRYPOINT /root/run.sh
