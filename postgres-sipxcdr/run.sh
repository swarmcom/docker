#!/bin/sh -e
docker run -td --name postgres-cdr -h postgres.cdr -p 5442:5432 -v `pwd`/data/pgdata:/var/lib/postgresql/data ezuce/postgres-cdr
