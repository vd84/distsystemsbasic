-module(replypool).
-export([start/2, stop/0]).

start(Port, N) ->
	register(rudy, spawn(fun() -> init(Port, N) end)).
	
stop() ->
	exit(whereis(rudy), "time to die").

init(Port, N) -> 
	Opt = [list, {active, false}, {reuseaddr, true}],
	case gen_tcp:listen(Port, Opt) of
		{ok, Listen} -> 
			handlers(Listen, N),
			super();
	{error, Error} -> 
		error
	end.

super() ->
	receive
	stop ->
		ok
	end.

handlers(Listen, N) ->
	case N of
	0 ->
		ok;
	N ->
		spawn(fun() -> handler(Listen, N) end),
		handlers(Listen, N-1)
	end.

handler(Listen, I) ->
	case gen_tcp:accept(Listen) of
		{ok, Client} ->
			request(Client),
			handler(Listen, I),
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
			gen_tcp:send(Client, Response);
		{error, Error} ->
			io:format("rudy: error: ~w~n", [Error])
			end,
			gen_tcp:close(Client).

reply({{get, URI, _}, Headers, Body}) ->
	timer:sleep(40),
	http:ok("You used GET " ++ Body);
reply({{post, URI, _}, Headers, Body}) ->
	http:ok("You used POST " ++ Body).
