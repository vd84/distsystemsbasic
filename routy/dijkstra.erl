-module(dijkstra).
-export([update/4]).

compare(A, B) ->
	{_, N1, _} = A,
	{_, N2, _} = B,
    case N1 == N2 of
        true ->
            N1 > N2;
        _ ->
            N1 < N2
    end.
update(_, _, _, [], Acc) ->
	lists:sort(fun compare/2, Acc);
update(Node, N, Gateway, [{Node, _, _}|T], Acc) ->
	update(Node, N, Gateway, T, Acc ++ [{Node, N, Gateway}]);
update(Node, N, Gateway, [H|T], Acc) ->
	update(Node, N, Gateway, T, Acc ++ [H]).
update(Node, N, Gateway, Sorted) ->
	update(Node, N, Gateway, Sorted, []).


iterate(Sorted, Map, Table) ->
	iterate(Sorted, Map, Table).
