#!/usr/bin/env escript

main([OurNode, Cookie, Node, M, F|A]) ->
	{ok, _} = net_kernel:start([l2a(OurNode), longnames]),
	erlang:set_cookie(node(), l2a(Cookie)),
	Re = rpc:call(l2a(Node), l2a(M), l2a(F), fix_args(A)),
	io:format("~p~n", [Re]);
main(_) ->
    usage().

usage() ->
    io:format("usage: OurNode Cookie RemoteNode Module Fun Arg...\n"),
    halt(1).

l2a(L) -> erlang:list_to_atom(L).
l2b(L) -> erlang:list_to_binary(L).
l2i(L) -> erlang:list_to_integer(L).

fix_args(Args) ->
	[ fix_arg(Arg) || Arg <- Args ].

fix_arg("a:"++Arg) -> l2a(Arg);
fix_arg("b:"++Arg) -> l2b(Arg);
fix_arg("i:"++Arg) -> l2i(Arg);
fix_arg(Arg) -> Arg.
