#!/usr/bin/env bash
echo "running on the remote machine!!!"
sudo docker run -d --name mongodb ezuce/mongodb
sudo docker run -d --name redis ezuce/redis
sudo docker run -d --name redis ezuce/freeswitch
sudo docker run -d --name redis ezuce/erlang
