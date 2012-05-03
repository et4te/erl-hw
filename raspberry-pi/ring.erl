-module(ring).

-export([create/4]).

%%------------------------------------------------------------------------------
%% Process Ring
%%------------------------------------------------------------------------------
%%  A process ring is a ring of relay processes (see relay.erl). The ring module
%% is in charge of creating process rings, and ensuring that they are connected
%% together in a ring.
%%------------------------------------------------------------------------------

%%------------------------------------------------------------------------------
%% The create function is in charge of creating a ring of relays, and connecting
%% each together linearly.
%%------------------------------------------------------------------------------
create(Size, RevolutionLimit, Led, TestPid) ->
    create(Size, Size, RevolutionLimit * Size, Led, TestPid, []).

create(0, _RingSize, _RelayLimit, _Led, _TestPid, Ring) ->
    [FirstRelay|Rest] = Ring,
    connect(FirstRelay, Rest, first);
create(N, RingSize, RelayLimit, Led, TestPid, Ring) ->
    Relay = relay:create(RingSize, RelayLimit, Led, TestPid),
    create(N-1, RingSize, RelayLimit, Led, TestPid, [Relay|Ring]).

%%------------------------------------------------------------------------------
connect(InitialRelay, [NextRelay|Ring], first) ->
    InitialRelay ! {connect, NextRelay},
    connect(InitialRelay, [NextRelay|Ring], next);

connect(InitialRelay, [LastRelay], next) ->
    LastRelay ! {connect, InitialRelay},
    InitialRelay;
connect(InitialRelay, [FirstRelay,NextRelay|Ring], next) ->
    FirstRelay ! {connect, NextRelay},
    connect(InitialRelay, [NextRelay|Ring], next).



    

    
    
