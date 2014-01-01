-module(exercise2).
-export([go/2]).

child(N) ->
    if
        N == 1 ->
            receive
                {Root, Msg} ->
                    io:fwrite(
                        "child ~w sending message back to root: ~w~n",
                        [N, Msg]),
                    Root ! Msg
            end;
        N > 1 ->
            Child = spawn(fun() -> child(N-1) end),
            receive
                {Root, Msg} ->
                    io:fwrite("child ~w relaying message: ~w~n", [N, Msg]),
                    Child ! {Root, Msg}
            end
    end.

go(N, Msg) ->
    if
        N =< 0 -> error;
        N > 0 ->
            io:fwrite("sending message via ~w children: ~w~n", [N, Msg]),
            Child = spawn(fun() -> child(N) end),
            Child ! {self(), Msg},
            receive
                Msg ->
                    io:fwrite("received message from last child: ~w~n", [Msg])
            end
    end.
