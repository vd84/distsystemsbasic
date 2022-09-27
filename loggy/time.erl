-module(time).
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

compare(A, B) ->
	{_, N1} = A,
	{_, N2} = B,
    case N1 == N2 of
        true ->
            N1 > N2;
        _ ->
            N1 < N2
    end.

zero() ->
	0.

inc(_Name, T) ->
	T + 1.

merge(Ti, Tj) ->
	case Ti > Tj of
		true ->
			Ti;
		_ -> 
			Tj
	end.	

leq(Ti, Tj) ->
	case Ti =< Tj of
		true ->
			true;
		_ -> 
			false
	end.
clock([], Acc) -> 
	lists:sort(fun compare/2, Acc);
clock([H|T], Acc) -> 
	Updated_Acc = lists:append([{H, 0}], Acc),
	clock(T, Updated_Acc).
clock(Nodes) -> 	
	clock(Nodes, []).
update(Node, Time, Clock) -> 
	Updated_Clock = lists:keyreplace(Node, 1, Clock, {Node, Time}),
	lists:sort(fun compare/2, Updated_Clock).

safe(Time, Clock) -> 
	{_, Smallest_Time} = lists:nth(1, Clock),

	leq(Time, Smallest_Time).
		

