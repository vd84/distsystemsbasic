-module(timeVect).
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
	[].

inc(Name, Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Found_Name, Found_Value} ->
            lists:keyreplace(Name, 1, Time, {Found_Name, Found_Value + 1});
        false ->
            [[]|Time]
end.

merge([], Time) ->
    Time;
merge([{Name, Ti}|Rest], Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, Tj} ->
            [{Name, Tj} |merge(Rest, lists:keydelete(Name, 1, Time))];
        false ->
            [[]  |merge(Rest, Time)]
end.	

leq([], _) ->
    false;
leq([{Name, Ti}|Rest],Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, Tj} ->
            if
                Ti =< Tj ->
                   true;
			true -> false
			end; 
		false ->
			leq(Rest, Time)
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
		

