Continous integration
=====================

This is a meta container intended to build other containers in controlled environment.
In theory it should be possible to build all components with it, the only thing you need to provide is
access to hosts docker socket, see [run.sh](ezuce-ci/run.sh), and GitHub auth token to have
access to private repo's.

In ezuce-ci folder:

```sh
./build.sh $TOKEN
./run.sh $TOKEN
docker exec ezuce-ci ./build.sh
or
docker exec ezuce-ci 'cd reach && ./build.sh'
```
