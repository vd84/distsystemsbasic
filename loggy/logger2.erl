-module(logger2).
-export([start/1, stop/1]).
start(Nodes) ->
	spawn_link(fun() ->init(Nodes) end).
stop(Logger) ->
	Logger ! stop.
init(Nodes) ->
	loop(time:clock(Nodes), []).

loop(Clock, Queue) ->
	receive
		{log, From, Time, Msg} ->
				Updated_Clock = time:update(From, Time, Clock),
				Updated_Queue = lists:append([{From, Time, Msg}], Queue),
				New_Queue = print_queue(Updated_Queue, Updated_Clock, []),
				loop(Updated_Clock, New_Queue);
		stop ->
			ok
	end.
	log(From, Time, Msg) ->
	io:format("log: ~w ~w ~p~n", [Time, From, Msg]).
print_queue([], _, Kept) ->
	Kept;
print_queue([{From, Time, Message}|T], Clock, Kept) ->
	case time:safe(Time, Clock) of
		true -> 
			log(From, Time, Message),
			print_queue(T, Clock, Kept);
		false ->
			print_queue(T, Clock, [{From, Time, Message}|Kept])
end.


