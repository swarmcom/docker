#!/bin/sh -e
cd reach
exec /home/user/reach/erts-8.3/bin/erl \
	-name remsh@$HOSTNAME \
	-remsh $NODE \
	-boot start_clean \
	-boot_var ERTS_LIB_DIR /home/user/erlang/lib \
	-setcookie ClueCon \
	-hidden \
	-kernel net_ticktime 60
