#!/bin/sh -e
cd busytone
exec /home/user/erlang/erts-8.3/bin/erl \
	-name remsh@$HOSTNAME \
	-remsh $NODE \
	-boot start_clean \
	-boot_var ERTS_LIB_DIR /home/user/erlang/lib \
	-setcookie ClueCon \
	-hidden -kernel net_ticktime 60
