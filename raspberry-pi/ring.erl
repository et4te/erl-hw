-module(ring).

-export([create/4]).

%%------------------------------------------------------------------------------
%% Create a Ring of size Size, where each message may be passed around the ring
%% at most RevolutionLimit times.
%%
%% This function is meant to be exported by this module.
%%------------------------------------------------------------------------------
create(Size, RevolutionLimit, Led, TestPid) ->
    create(Size, Size, RevolutionLimit * Size, Led, TestPid, []).

%%------------------------------------------------------------------------------
%% Create a ring of relays and connect each together linearly.
%%------------------------------------------------------------------------------
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



    

    
    
