FROM busybox
MAINTAINER Roman Galeev <jamhedd@gmail.com>

RUN adduser -D user && mkdir -p /home/user/rr/data && chown -R user:user /home/user/rr/data

VOLUME /home/user/rr/data
