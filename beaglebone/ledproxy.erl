-module(ledproxy).
-import(bbled).
-export([init/1]).

init(Pin) ->
	Fd = bbled:init(Pin),
	run(Fd).

run(Fd) ->
	receive
		{state, on} ->
			bbled:on(Fd);
		{state, off} ->
			bbled:off(Fd)
	end,
	run(Fd).

