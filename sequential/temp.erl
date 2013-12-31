-module(temp).
-export([f2c/1, c2f/1, convert/1]).

f2c(F) -> 5 * (F - 32) / 9.

c2f(C) -> 9 * C / 5 + 32.

convert({c, C}) -> c2f(C);
convert({f, F}) -> f2c(F).
