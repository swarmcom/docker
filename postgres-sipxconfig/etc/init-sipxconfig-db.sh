#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE SIPXCONFIG WITH TEMPLATE = template0;
    GRANT ALL PRIVILEGES ON DATABASE SIPXCONFIG TO postgres;
EOSQL

psql --username "$POSTGRES_USER" sipxconfig < /etc/V1__Initial.sql
