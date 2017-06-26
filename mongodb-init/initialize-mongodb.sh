#!/bin/sh -e
sleep 10s

mongo --host mongo --eval 'rs.initiate()'
