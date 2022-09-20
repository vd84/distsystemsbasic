-module(dijkstra).
-export([update/4, iterate/3, table/2, route/2]).

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


update_all_sorted([], _, _, Sorted) ->
	Sorted;
update_all_sorted([H|T], N, Gateway, Sorted) ->
	Updated_Sorted = update(H, N, Gateway, Sorted),
	update_all_sorted(T, N, Gateway, Updated_Sorted).

iterate([], _, Table) ->
	Table;
iterate([{Node, Length, Gateway} | T], Map, Table) ->
	if
		Length == inf ->
			Table;
		true ->
			All_Reachable = map:reachable(Node, Map),
			NewSorted = update_all_sorted(All_Reachable, Length+1, Gateway, [{Node, Length, Gateway} | T]),
			NewSortedDel = lists:keydelete(Node, 1, NewSorted),
			NewTable = lists:append(Table, [{Node, Gateway}]),
			iterate(NewSortedDel, Map, NewTable)
	end.
update_gateways([], Sorted) -> 
	Sorted;
update_gateways([H|T], Sorted) -> 
	NewSorted = update(H, 0, H, Sorted),
	update_gateways(T, NewSorted).

create_dummy_list([], Sorted) ->
	Sorted;
create_dummy_list([H|T], Sorted) ->
	NewSorted = lists:append(Sorted, [{H, inf, unknown}]),
	create_dummy_list(T, NewSorted).

table(Gateways, Map) ->
	AllNodes = map:all_nodes(Map),
	io:format("~w~n", [AllNodes]),
	Dummy_List = create_dummy_list(AllNodes, []),
	SortedGateways = update_gateways(Gateways, Dummy_List),
	iterate(SortedGateways, Map, []).
route(Node, Table) ->
	case lists:keyfind(Node, 1, Table) of
		{_, Gateway} ->
			{ok, Gateway};
		_ ->
			notfound
	end.

