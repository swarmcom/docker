# Kamailio

This is a SIP registrar and Reach SIP ingress proxy.

## Production

Try to guess external ip:
```sh
SIP_DOMAIN=docker.ezuce.com ./run.sh
```

Provide hosts external ip:
```sh
EXT_IP=1.1.1.1 SIP_DOMAIN=docker.ezuce.com ./run.sh
```

## Development

Reach is running on host:
```sh
EXT_IP=kamailio.ezuce REACH_NODE=reach@172.17.0.1 ./run.sh
```

Reach is running in container (with standard name):
```sh
EXT_IP=kamailio.ezuce ./run.sh
```
