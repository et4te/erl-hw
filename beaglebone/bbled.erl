-module(bbled).
-export([init/1, on/1, off/1, blink/2]).

init(Pin) when Pin >= 0, Pin < 4 ->
	{ok, Fd} = file:open("/sys/class/leds/beaglebone::usr" ++ integer_to_list(Pin) ++ "/brightness", [write]),
	Fd.

on(Fd) ->
	file:write(Fd, "1").

off(Fd) ->
	file:write(Fd, "0").

blink(Fd, Delay) ->
	on(Fd),
	timer:sleep(Delay),
	off(Fd),
	timer:sleep(Delay).

