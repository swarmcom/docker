#!/bin/bash
set -e
createdb -U $POSTGRES_USER --encoding=UNICODE --template=template0 sipxcdr
psql -f /etc/V1__Initial.sql
psql -f /etc/cdrremote.sql
