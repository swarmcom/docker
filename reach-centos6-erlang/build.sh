#!/bin/sh -e
docker build $BUILD_FLAGS -t ezuce/reach-centos6-erlang \
	--build-arg REPO=$REPO \
	--build-arg BRANCH=$BRANCH \
	.
