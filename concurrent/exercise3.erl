-module(exercise3).
-export([go/3]).

child(N) ->
    receive
        {Sender, Msg} ->
            Self = self(),
            io:fwrite(
                "Child ~w with pid ~w received message ~w~n",
                [N, Self, Msg]),
            Sender ! Msg,
            child(N);
        stop -> ok
    end.

spawn_children(N, Acc) ->
    if
        N < 0 -> error;
        N == 0 -> Acc;
        N > 0 ->
            Child = spawn(fun() -> child(N) end),
            io:fwrite("spawned child ~w~n", [N]),
            spawn_children(N-1, [Child|Acc])
    end.

ping_each(Procs, M, Msg) ->
    if
        M < 0 -> error;
        M == 0 -> ok;
        M > 0 ->
            Self = self(),
            lists:foreach(
                fun(Proc) ->
                    Proc ! {Self, Msg},
                    receive
                        Msg -> ok
                    end
                end,
                Procs),
            ping_each(Procs, M-1, Msg)
    end.

go(N, M, Msg) ->
    Children = spawn_children(N, []),
    ping_each(Children, M, Msg),
    lists:foreach(
        fun(Proc) -> Proc ! stop end,
        Children).
