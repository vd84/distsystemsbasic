-module(intf).
-export([new/0, add/4, remove/2, lookup/2, ref/2, list/1, name/2, broadcast/2]).

new() ->
	[].
add(Name, Ref, Pid, Intf) ->
	lists:append(Intf, [{Name, Ref, Pid}]).

remove(Name, Intf) ->
	lists:keydelete(Name, 1, Intf).

lookup(Name, Intf)  ->
	case lists:keyfind(Name, 1, Intf) of
        {NameFound, Ref, Pid} ->
			{ok, Pid};
		false ->
            notfound
    end.

ref(Name, Interface) ->
	case lists:keyfind(Name, 1, Interface) of
		false ->
			notfound;
		{_, Ref, _} ->

			{ok, Ref}
	end.
	
name(Ref, Intf) ->
	case lists:keyfind(Ref, 2, Intf) of
		false ->
			notfound;
		{Name, _, _} ->
			{ok, Name}
	end.
list([], Acc) -> 
	Acc;
list([{Name, Ref, Pid}|T], Acc) -> 
	list(T, lists:append(Acc, [Name])).

list(Interface) ->
	list(Interface, []).

broadcast(Message, []) ->
	ok;
broadcast(Message, [{Name, Ref, Pid}|T]) ->
		Pid ! Message,
		broadcast(Message, T).
