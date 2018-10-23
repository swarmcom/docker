FROM busybox
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

RUN adduser -D user && mkdir -p /home/user/rr/data && chown -R user:user /home/user/rr/data

VOLUME /home/user/rr/data
