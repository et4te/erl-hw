-module(piled).
-export([init/1, on/1, off/1, blink/2]).

init(Pin) ->
	{ok, FdExport} = file:open("/sys/class/gpio/export", [write]),
	file:write(FdExport, integer_to_list(Pin)),
	file:close(FdExport),

	{ok, FdPinDir} = file:open("/sys/class/gpio/gpio" ++ integer_to_list(Pin) ++ "/direction", [write]),
	file:write(FdPinDir, "out"),
	file:close(FdPinDir),

	{ok, FdPinVal} = file:open("/sys/class/gpio/gpio" ++ integer_to_list(Pin) ++ "/value", [write]),
	FdPinVal.

on(Fd) ->
	file:write(Fd, "1").

off(Fd) ->
	file:write(Fd, "0").

blink(Fd, Delay) ->
	on(Fd),
	timer:sleep(Delay),
	off(Fd),
	timer:sleep(Delay).

