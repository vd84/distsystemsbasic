-module(worker2).

-export([start/5, stop/1, peers/2]).

start(Name, Logger, Seed, Sleep, Jitter) ->
    spawn_link(fun() -> init(Name, Logger, Seed, Sleep, Jitter) end).

stop(Worker) ->
    Worker ! stop.

init(Name, Log, Seed, Sleep, Jitter) ->
    random:seed(Seed, Seed, Seed),
    receive
	{peers, Peers} ->
	    loop(Name, Log, Peers, Sleep, Jitter, time:zero());
	stop ->
	    ok
    end.

peers(Wrk, Peers) ->
    Wrk ! {peers, Peers}.

loop(Name, Log, Peers, Sleep, Jitter, NodeTime) ->
    Wait = random:uniform(Sleep),
    receive
	{msg, Time, Msg} ->
	    Inc_time = time:inc(Name, time:merge(NodeTime, Time)),
	    Log ! {log, Name, Inc_time, {received, Msg}},
	    loop(Name, Log, Peers, Sleep, Jitter, Inc_time);
	stop ->
	    ok;
	Error ->
	    Log ! {log, Name, time, {error, Error}}
    after Wait ->
	    Selected = select(Peers),
	    Inc_time = time:inc(Name, NodeTime),
	    Message = {hello, random:uniform(500)},
	    Selected ! {msg, Inc_time, Message},
	    jitter(Jitter),
	    Log ! {log, Name, Inc_time, {sending, Message}},
	    loop(Name, Log, Peers, Sleep, Jitter, Inc_time)
    end.

select(Peers) ->
    lists:nth(random:uniform(length(Peers)), Peers).

jitter(0) ->
    ok;
jitter(Jitter) ->
    timer:sleep(random:uniform(Jitter)).
