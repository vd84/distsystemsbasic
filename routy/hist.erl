-module(hist).
-export([new/1, update/3]).

new(Name) ->
  [{Name, 0}].

update(Node, N, History) ->
    case lists:keyfind(Node, 1, History) of
        {Node, Counter} ->
            if N > Counter ->
                {new, lists:keyreplace(Node, 1, History, {Node, N})};
            true ->
                old
            end;
    _ ->
	   {new, [{Node, N}|History]}
    end.
