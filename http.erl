-module(http).
-export([parse_request/1]).

parse_request(R0) ->
	{Request, R1} = request_line(R0),
	{Headers, R2} = headers(R1),
	{Body, _} = message_body(R2),
	{Request, Headers, Body}.

request_line([$G, $E, $T, 32 |R0]) ->
	{URI, R1} = request_uri(R0),
	{Ver, R2} = http_version(R1),
	[13,10|R3] = R2,
	{{get, URI, Ver}, R3}.
