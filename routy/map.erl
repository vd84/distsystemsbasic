-module(map).
-export([new/0, update/3, reachable/2, all_reachable/3]).

new() -> 
    [].

update(Node, Links, Map) -> 
    [{Node, Links}].

all_reachable(Node, [], Reachable) -> {Node, Reachable};
all_reachable(Node, [{Node, List}|T], Reachable) -> 
    all_reachable(Node, T, Reachable ++ List);
all_reachable(Node, [H|T], Reachable) -> 
    all_reachable(Node, T, Reachable).

reachable(Node, Map) -> 
    all_reachable(Node, Map, []).