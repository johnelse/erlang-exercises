-module(lists1).
-export([min/1, max/1, min_max/1]).

min_internal([], Min) -> Min;
min_internal([H|T], Min) ->
    if
        Min =< H -> min_internal(T, Min);
        Min > H -> min_internal(T, H)
    end.

min([H|T]) -> min_internal(T, H).

max_internal([], Max) -> Max;
max_internal([H|T], Max) ->
    if
        Max >= H -> max_internal(T, Max);
        Max < H -> max_internal(T, H)
    end.

max([H|T]) -> max_internal(T, H).

min_max(L) -> {min(L), max(L)}.
