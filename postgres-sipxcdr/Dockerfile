FROM postgres

COPY etc/init-sipxcdr-db.sh /docker-entrypoint-initdb.d/init-sipxcdr-db.sh
COPY etc/cdrremote.sql /etc/cdrremote.sql
COPY etc/V1__Initial.sql /etc/V1__Initial.sql
