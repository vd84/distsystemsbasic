-module(logger2).
-export([start/1, stop/1]).
start(Nodes) ->
	spawn_link(fun() ->init(Nodes) end).
stop(Logger) ->
	Logger ! stop.
init(Nodes) ->
	loop(time:clock(Nodes), []).

log_all_safe(Clock, Queue) ->
	ok.

loop(Clock, Queue) ->
	receive
		{log, From, Time, Msg} ->
			log(From, Time, Msg),
			io:format("updatedClock (~w) ~n", [Clock]),
			case time:safe(Time, Clock) of
				true -> 
					log(From, Time, Msg),
					Updated_Clock = time:update(From, Time, Clock),
					loop(Updated_Clock, Queue);
				_ -> 
					Updated_Queue = lists:append([{From, Time, Msg}], Queue),
					loop(Clock, Updated_Queue)
			end,
			loop(Clock, Queue);
		stop ->
			ok
	end.
	log(From, Time, Msg) ->
	io:format("log: ~w ~w ~p~n", [Time, From, Msg]).
