#!/bin/sh -e
. erlang/activate
./rpc.erl rpc@$HOSTNAME ClueCon $NODE $*
