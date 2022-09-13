-module(map).
-export([new/0, update/3, reachable/2, all_reachable/3, all_nodes/1]).

new() -> 
    [].

update(Node, Links, _) -> 
    [{Node, Links}].

all_reachable(_, [], Reachable) -> Reachable;
all_reachable(Node, [{Node, List}|T], Reachable) -> 
    all_reachable(Node, T, Reachable ++ List);
all_reachable(Node, [_|T], Reachable) -> 
    all_reachable(Node, T, Reachable).

all_nodes([], Nodes) -> Nodes;
all_nodes([{Node, List}|T], Nodes) -> 
	All = lists:append(List, Nodes),
	all_nodes(T, lists:append([Node], All)).
reachable(Node, Map) -> 
    all_reachable(Node, Map, []).

all_nodes(Map) ->
	all_nodes(Map, []).
