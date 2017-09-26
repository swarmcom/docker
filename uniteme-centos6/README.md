ReachMe Centos 6 container
==========================

It will build a ReachMe release in Centos 6 env. After make release you can copy
_build/ outside of the container, and it will be runnable in Centos 6.

Other option is to produce tar.gz file with:

```sh
$ rebar3 as prod tar
```
