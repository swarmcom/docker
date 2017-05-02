#!/bin/sh -e
. erlang/activate
cd reach
make site
make release
