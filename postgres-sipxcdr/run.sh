#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"postgres.cdr}

docker run $FLAGS \
 --name postgres-cdr \
 -h $NAME \
 -p 5442:5432 \
 -v `pwd`/data/pgdata:/var/lib/postgresql/data \
 $NETWORK/postgres-cdr
