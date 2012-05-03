-module(relay).

-export([create/4]).
-export([relay/5]).

%%------------------------------------------------------------------------------
%% Introduction
%%------------------------------------------------------------------------------
%% A relay is a process which relays a message it is sent to a next connected
%% relay when it receives it.
%%------------------------------------------------------------------------------

%%------------------------------------------------------------------------------
%% The create function is in charge of creating a disconnected relay process.
%%------------------------------------------------------------------------------
create(RingSize, RelayLimit, Led, TestPid) ->
    spawn(relay, relay, [disconnected, RingSize, RelayLimit, Led, TestPid]).

%%------------------------------------------------------------------------------
%% When a relay is initially spawned, it is in a disconnected state. The 
%% first parameter in the following function reflects this. Relays start off
%% this way so that we may connect two processes together which mutually depend
%% on one another. In this case, the last relay in the ring must be connected
%% to the first relay in the ring.
%%  A relay becomes connected when it receives the message {connect, NextRelay},
%% where the NextRelay represents the relay to connect to.
%%------------------------------------------------------------------------------
relay(disconnected, RingSize, RelayLimit, Led, TestPid) ->
    receive
        {connect, NextRelay} ->
            relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, off)
    end.

%%------------------------------------------------------------------------------
%% The connected relay must be parameterized with the following parameters:
%% * RingSize - In order to calculate when the token has completed a full 
%% revolution.
%% * RelayLimit - To stop the token from being passed around the ring.
%% * Led - The led file descriptor is required in order to communicate to the
%% led process, to turn it on and off.
%%------------------------------------------------------------------------------
relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, LedState) ->
    receive
        terminate ->
            NextRelay ! terminate;
        N when N >= RelayLimit ->
            TestPid ! done,
            NextRelay ! terminate;
        N when (N rem RingSize) == 0 ->
            NextLedState = 
                case LedState of
                    on  -> Led ! off, off;
                    off -> Led ! on, on
                end,
            NextRelay ! (N + 1),
            relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, NextLedState);
        N when N < RelayLimit ->
            NextRelay ! (N + 1),
            relay(connected, NextRelay, RingSize, RelayLimit, Led, TestPid, LedState)
    end.
