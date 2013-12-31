-module(time).
-export([swedish_date/0]).

last2([A,B]) -> [A,B];
last2([_|T]) -> last2(T).

swedish_date() ->
    {Year, Month, Day} = date(),
    Year_string = last2(integer_to_list(Year)),
    Month_string = integer_to_list(Month),
    Day_string = integer_to_list(Day),
    Year_string ++ Month_string ++ Day_string.
