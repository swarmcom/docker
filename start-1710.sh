#!/bin/bash
NETWORK=${1:-"ezuce"}
docker start mongodb.$NETWORK
docker start elastic.$NETWORK
docker start freeswitch.$NETWORK
docker start agents.$NETWORK
docker start rr.$NETWORK
