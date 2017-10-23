#!/bin/sh
git clone https://github.com/erlang/rebar3.git ./rebar
. ~/erlang/activate
cd rebar && ./bootstrap && cp rebar3 ../
