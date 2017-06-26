#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"ezuce"}
NAME=${NAME:-"mongodb.$NETWORK"}

docker run $FLAGS \
	--name mongo \
  -h $NAME \
  -p 27017:27017 \
  -v `pwd`/etc/mongodb.conf:/etc/mongo.config \
  -v `pwd`/mongo-data/data:/data/db \
  mongo mongod --config /etc/mongo.config

sleep 10s

docker exec -it mongo mongo --eval 'rs.initiate()'
