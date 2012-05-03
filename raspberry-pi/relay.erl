-module(relay).

-export([create/4]).
-export([relay/5]).

%%------------------------------------------------------------------------------
create(RingSize, RelayLimit, Led, TestPid) ->
    spawn(relay, relay, [disconnected, RingSize, RelayLimit, Led, TestPid]).

%%------------------------------------------------------------------------------
relay(disconnected, RingSize, RelayLimit, Led, TestPid) ->
    receive
        {connect, NextRelay} ->
            relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, off)
    end.

%%------------------------------------------------------------------------------
relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, LedState) ->
    receive
        terminate ->
            NextRelay ! terminate;
        N when N >= RelayLimit ->
            TestPid ! done,
            NextRelay ! terminate;
        N when (N rem RingSize) == 0 ->
            NextLedState = case LedState of
                               on  -> Led ! off, off;
                               off -> Led ! on, on
                           end,
            NextRelay ! (N + 1),
            relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, NextLedState);
        N when N < RelayLimit ->
            NextRelay ! (N + 1),
            relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, LedState)
    end.
