#!/bin/sh -e
wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.3.tar.gz
tar zxvf luarocks-2.4.3.tar.gz
cd luarocks-2.4.3
./configure
make build
make install
luarocks install http
ln -s /usr/local/share/lua/5.2/http_0_2_0-http /usr/local/share/lua/5.2/http
