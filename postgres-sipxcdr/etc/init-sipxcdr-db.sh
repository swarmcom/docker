#!/bin/bash
set -e
createdb -U $POSTGRES_USER --encoding=UNICODE --template=template0 sipxcdr
psql -U $POSTGRES_USER -f /etc/V1__Initial.sql sipxcdr
psql -U $POSTGRES_USER -f /etc/cdrremote.sql sipxcdr
