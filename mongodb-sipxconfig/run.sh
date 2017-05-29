#!/bin/sh -e

docker run -td \
	--name mongo \
  -p 27017:27017 \
  -v `pwd`/etc/mongodb.conf:/etc/mongo.config \
  -v `pwd`/mongo-data/data:/data/db \
  mongo mongod --config /etc/mongo.config

sleep 10s

docker exec -it mongo mongo --eval 'rs.initiate()'
