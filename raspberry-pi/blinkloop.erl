-module(blinkloop).
-import(piled).
-import(timer).
-export([run/2]).

run(Pin, Delay) ->
	Fd = piled:init(Pin),
	blink(Fd, Delay).

blink(Fd, Delay) ->
	piled:on(Fd),
	timer:sleep(Delay),
	piled:off(Fd),
	timer:sleep(Delay),
	blink(Fd, Delay).
	
