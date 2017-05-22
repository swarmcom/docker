#!/usr/bin/env bash
echo "running on the remote machine!!!"
sudo docker run --name mongodb ezuce/mongodb
sudo docker run --name mongodb ezuce/redis
