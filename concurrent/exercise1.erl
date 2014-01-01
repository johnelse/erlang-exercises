-module(exercise1).
-export([go/2]).

ping(0, Pong, _) ->
    Pong ! stop,
    ok;
ping(N, Pong, Msg) ->
    Pong ! {self(), Msg},
    receive
        {_, Msg} ->
            io:fwrite("ping got message: ~w~n", [Msg]),
            ping(N-1, Pong, Msg)
    end.

pong() ->
    receive
        {Ping, Msg} ->
            io:fwrite("pong got message: ~w~n", [Msg]),
            Ping ! {self(), Msg},
            pong();
        stop ->
            ok
    end.

go(N, Msg) ->
    if
        N < 0 -> error;
        N >= 0 ->
            Pong = spawn(fun() -> pong() end),
            ping(N, Pong, Msg)
    end.
