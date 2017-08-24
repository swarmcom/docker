#!/bin/sh -e
docker run -td --name sipxcdr -v `pwd`/conf/1/callresolver-config:/etc/sipxcdr/conf/callresolver-config --link postgres-cdr:postgres.cdr -h sipxcdr.ezuce -p 8130:8130 ezuce/sipxcdr
