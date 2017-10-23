#!/bin/sh -e
. ~/erlang/activate
git clone https://github.com/erlang/rebar3.git ./rebar
cd rebar && ./bootstrap && cp rebar3 ../
