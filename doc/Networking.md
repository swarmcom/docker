Networking
==========

A docker host could have one or more virtual networks. Each network could have one or more services (running containers).
Each network reprepsents a complete working environment (e.g. a combination of various versions of services). In order to make
it all work we use so called ingress containers. The sole purpose of an ingress container is to route traffic from outside world
to the propriate docker internal network. So, an ingress proxy must have access to all (or specified) docker networks. We can
do this in two ways: enable ip routing between virtual docker networks (by removing ip tables rule), or by putting ingress
proxy container to all networks.

HTTP
====

We use nginx as an ingress http/https proxy. Each docker network service is represented by a virtual host. Some efforts are made
to allow https certificates to be generated per each virtual domain.

SIP
===

In order to proxy SIP traffic into a docker network a full SIP proxy is required. A full SIP proxy handles SIP and RTP packets
and alters them as needed. We use simple FreeSWITCH configuration to route SIP calls to the propriate docker internal networks,
based on SIP domain value. The FreeSWITCH instance has two so-called SIP profiles: internal and external ones. The external
SIP profile must be configured to forcefully use the docker host external IP address, and we can distinguish the internal
profile from the external just by SIP port number (e.g. 6060 for the internal profile, and 5060 for the external one).

This setup does not support SIP registrations though. For this need to use a more advanced setup, namely:

1. Use kamailio with modules and/or intense lua scripting
2. Use FreeSWITCH as a SIP registrar, with/without intense lua scripting
3. Have a way to develop a SIP proxy we currently have

