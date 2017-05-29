SipXcom container
=================

By default container builds itself by downloading sources from Github and then configuring and building inside of
container. This is how:
```sh
./build.sh
./run.sh
```

It is also possible to have a source tree outside of a container, here is how:
```sh
SKIP_BUILD=1 ./build.sh
SIPX_SOURCE=~/ezuce-docker/sipxcom/src/sipxecs ./run.sh 
```
Then you can configure/build it with:
```
docker exec -it sipxcom.ezuce build/setup.sh
docker exec -it sipxcom.ezuce build/build.sh
```
