-module(ms).
-export([start/1, to_slave/2]).

slave(N) ->
    receive
        die -> exit({die, N});
        Message ->
            io:fwrite("slave ~w got message ~w~n", [N, Message]),
            slave(N)
    end.

spawn_slave(N) ->
    Slave = spawn(fun() -> slave(N) end),
    link(Slave),
    Slave.

spawn_slaves(N, Acc) ->
    if
        N == 0 -> Acc;
        N > 0 ->
            Slave = spawn_slave(N),
            spawn_slaves(N-1, dict:store(N, Slave, Acc))
    end.

master_mainloop(Slaves) ->
    receive
        {Message, N} ->
            case dict:find(N, Slaves) of
                error -> io:fwrite("slave ~w doesn't exist~n", [N]);
                {ok, Slave} -> Slave ! Message
            end,
            master_mainloop(Slaves);
        {'EXIT', _, {die, N}} ->
            io:fwrite("master restarting dead slave ~w~n", [N]),
            New_slave = spawn_slave(N),
            New_slaves = dict:store(N, New_slave, Slaves),
            master_mainloop(New_slaves)
    end.

master_start(N) ->
    process_flag(trap_exit, true),
    io:fwrite("master spawning slaves~n"),
    Slaves = spawn_slaves(N, dict:new()),
    io:fwrite("master starting main loop~n"),
    master_mainloop(Slaves).

start(N) ->
    if
        N < 0 -> error;
        N >= 0 ->
            Master = spawn(fun() -> master_start(N) end),
            register(master, Master),
            ok
    end.

to_slave(Message, N) ->
    master ! {Message, N},
    ok.
