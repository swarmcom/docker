#!/bin/sh -e
git clone https://github.com/erlang/rebar3.git ./rebar
ls
. ~/erlang/activate
cd rebar && ./bootstrap && cp rebar3 ../
