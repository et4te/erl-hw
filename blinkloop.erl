-module(blinkloop).
-import(bbled).
-import(timer).
-export([run/2]).

run(Pin, Delay) ->
	Fd = bbled:init(Pin),
	blink(Fd, Delay).

blink(Fd, Delay) ->
	bbled:on(Fd),
	timer:sleep(Delay),
	bbled:off(Fd),
	timer:sleep(Delay),
	blink(Fd, Delay).
	
