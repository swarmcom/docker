#!/bin/sh -e
NETWORK=${NETWORK:-"ezuce"}
docker build -t $NETWORK/basecentos .
