ReachMe FreeSWITCH drone
========================

This instance of FreeSWITCH is supposed to work in conjunction with ReachMe.
By default it accepts all calls and routes them to ReachMe.

Run
===

In order to run it you need to provide ReachMe node name (as environment variable).


```sh
REACH_NODE=reach@172.17.0.1 REACH_HOST=http://172.17.0.1:8937 ./run.sh
```
