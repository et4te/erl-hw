-module(ledproxy).
-import(piled).
-export([init/1]).

init(Pin) ->
	Fd = piled:init(Pin),
	run(Fd).

run(Fd) ->
	receive
	{state, on} ->
		piled:on(Fd);
	{state, off} ->
		piled:off(Fd)
	end,

	run(Fd).

