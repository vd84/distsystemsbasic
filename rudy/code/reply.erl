-module(reply).
-export([start/1, stop/0]).

start(Port) ->
	register(rudy, spawn(fun() -> init(Port) end)).
	
stop() ->
	exit(whereis(rudy), "time to die").

init(Port) -> 
	Opt = [list, {active, false}, {reuseaddr, true}],
	case gen_tcp:listen(Port, Opt) of
		{ok, Listen} -> 
			handler(Listen),
		gen_tcp:close(Listen),
		ok;
	{error, Error} -> 
		error
	end.

handler(Listen) ->
	case gen_tcp:accept(Listen) of
		{ok, Client} ->
			spawn(fun() -> request(Client) end),
			handler(Listen),
			ok;
		{error, Error} ->
			error
	end.

request(Client) -> 
	Recv = gen_tcp:recv(Client, 0),
	case Recv of
		{ok, Str} ->
			Request = http:parse_request(Str),
			Response = reply(Request),
			gen_tcp:send(Client, Response),
			gen_tcp:close(Client);
		{error, Error} ->
			io:format("rudy: error: ~w~n", [Error]),
			ok
	end.

reply({{get, URI, _}, Headers, Body}) ->
	http:ok("You used GET " ++ Body);
reply({{post, URI, _}, Headers, Body}) ->
	http:ok("You used POST " ++ Body).
