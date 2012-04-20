-module(gpio).
-export([init/2, release/1]).

init(Pin, Direction) ->
  {ok, FdExport} = file:open("/sys/class/gpio/export", [write]),
  file:write(FdExport, integer_to_list(Pin)),
  file:close(FdExport),

  {ok, FdPinDir} = file:open("/sys/class/gpio/gpio" ++ integer_to_list(Pin) ++ "/direction", [write]),
  case Direction of
    in  -> file:write(FdPinDir, "in");
    out -> file:write(FdPinDir, "out")
  end,
  file:close(FdPinDir),

  {ok, FdPinVal} = file:open("/sys/class/gpio/gpio" ++ integer_to_list(Pin) ++ "/value", [write]),
  FdPinVal.

release(Pin) ->
  {ok, FdUnexport} = file:open("/sys/class/gpio/unexport", [write]),
  file:write(FdUnexport, integer_to_list(Pin)),
  file:close(FdUnexport).

