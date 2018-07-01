#!/bin/sh -e
NETWORK=${NETWORK:-"reach3"}
./rpc.erl rpc@reach.$NETWORK ClueCon $NODE $*
