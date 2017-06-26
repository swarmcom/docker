#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"postgres.$NETWORK"}

docker run $FLAGS \
 --name postgres \
 -h $NAME \
 -p 5432:5432 \
 -v `pwd`/data/pgdata:/var/lib/postgresql/data \
 $NETWORK/postgres
