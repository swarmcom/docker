#!/bin/sh -e
docker build $BUILD_FLAGS -t reach3/reach -t reach3/reach:3.0.0 .
