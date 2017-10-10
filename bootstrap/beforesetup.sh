#!/bin/sh

echo "Configuring docker.Please wait..."
mkdir -p /etc/systemd/system/docker.service.d/ && \
cd /etc/systemd/system/docker.service.d && \
rm -rf docker.conf && \
touch docker.conf

cat > docker.conf << EOL
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
EOL
systemctl daemon-reload
systemctl restart docker

clear
