-module(led).
-import(gpio).
-export([start/1, stop/1, loop/1]).

start(Pin) ->
  Fd = gpio:init(Pin, out),
  Pid = spawn(?MODULE, loop, [Fd, Pin]),
  Pid.

stop(Pid) ->
  Pid ! stop.

loop(Fd, Pin) ->
  receive
    on -> 
      file:write(Fd, "1"),
      loop(Fd, Pin);
    off ->
      file:write(Fd, "0"),
      loop(Fd, Pin);
    {blink, Delay} ->
      file:write(Fd, "1"),
      timer:sleep(Delay),
      file:write(Fd, "0"),
      timer:sleep(Delay),
      self() ! {blink, Delay},
      loop(Fd, Pin);
    stop ->
      file:close(Fd),
      gpio:release(Pin),
      ok
  end.

