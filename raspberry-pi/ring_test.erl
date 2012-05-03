-module(ring_test).

-export([start/4]).

%%------------------------------------------------------------------------------
start(R1Size, R2Size, R3Size, R4Size) ->
    spawn(fun () -> start_test(R1Size, R2Size, R3Size, R4Size) end).

%%------------------------------------------------------------------------------
start_test(R1Size, R2Size, R3Size, R4Size) ->
    Led1 = led:start(17),
    Led2 = led:start(18),
    Led3 = led:start(21),
    Led4 = led:start(22),

    FirstRelay1 = ring:create(R1Size, 100, Led1, self()),
    FirstRelay2 = ring:create(R2Size, 100, Led2, self()),
    FirstRelay3 = ring:create(R3Size, 100, Led3, self()),
    FirstRelay4 = ring:create(R4Size, 100, Led4, self()),
                 
    FirstRelay1 ! 0,
    FirstRelay2 ! 0,
    FirstRelay3 ! 0,
    FirstRelay4 ! 0,

    receive done -> ok end,
    receive done -> ok end,
    receive done -> ok end,
    receive done -> ok end,

    FirstRelay1 ! terminate,
    FirstRelay2 ! terminate,
    FirstRelay3 ! terminate,
    FirstRelay4 ! terminate,

    led:stop(Led1),
    led:stop(Led2),
    led:stop(Led3),
    led:stop(Led4).

