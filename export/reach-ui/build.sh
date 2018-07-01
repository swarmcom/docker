#!/bin/sh -e
HUB=${HUB:-"reach3"}
docker build $BUILD_FLAGS -t $HUB/reach-ui -t $HUB/reach-ui:3.1.0 .
