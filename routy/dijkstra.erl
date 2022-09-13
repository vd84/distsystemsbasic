-module(dijkstra).
-export([update/4]).
reverse(L) -> reverse(L,[]).
reverse([],R) -> R;
reverse([H|T],R) -> reverse(T,[H|R]). 
update(_, _, _, [], Acc) ->
	reverse(Acc);
update(Node, N, Gateway, [{Node, _, _}|T], Acc) ->
	update(Node, N, Gateway, T, Acc ++ [{Node, N, Gateway}]);
update(Node, N, Gateway, [H|T], Acc) ->
	update(Node, N, Gateway, T, Acc ++ [H]).
update(Node, N, Gateway, Sorted) ->
	update(Node, N, Gateway, Sorted, []).
