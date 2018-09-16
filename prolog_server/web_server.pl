:- use_module(library(http/thread_httpd)).

:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_path)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_session)).
:- use_module(library(http/http_wrapper)).

:- use_module(library(http/html_write)).
:- use_module(library(http/json_convert)).

:- ensure_loaded([commands]).
:- ensure_loaded([gamestate]).


% STATIC FILES

% index.html, images/, third/, lib/

http:location(images, root(images), []).
http:location(third, root(third), []).
http:location(lib, root(lib), []).

user:file_search_path(document_root, '../frontend/site').
user:file_search_path(images,	document_root(images)).
user:file_search_path(third, document_root(third)).
user:file_search_path(lib, document_root(lib)).

%:- http_handler('/favicon.ico', http_reply_file('favicon.ico', []), []).
:- http_handler(root(.), http_reply_file(document_root('index.html'), []), []).		% (1)
:- http_handler(images(.), serve_files_in_directory(images), [prefix]).
:- http_handler(third(.), serve_files_in_directory(third), [prefix]).
:- http_handler(lib(.), serve_files_in_directory(lib), [prefix]).


% PROLOG API

:- http_handler(root(hello_world), say_hi, []).
:- http_handler(root(command), command, []).
:- http_handler(root(echo), echo, []).

server(Port) :-
				http_server(http_dispatch, [port(Port)]).

command(Request) :-
				http_read_json_dict(Request, Parameters),
				get_dict(command, Parameters, RawCommand),
				split_string(RawCommand," ","",CommandStrings),
				maplist(atom_string,Command,CommandStrings),
				command(Parsed,Command,[]),
				apply_command(Parsed,Result),
				prolog_to_json(Result,Json),
				reply_json_dict(Json).

% apply_command

apply_command(info,"Information goes here...").
apply_command(help,"I know this isn't very helpful...").

apply_command(reset,GameState) :-
				http_session_retractall(player_level(_)),
				http_session_retractall(zone(_)),
				http_session_retractall(active_monster(_,_,_,_,_)),
				%%% create new state
				http_session_assert(player_level(1)),
				http_session_assert(zone(factory0)),
				findall([monster,X,Y,N,L,Hp],monster(X,Y,N,L,Hp),GameState).
				
apply_command(action(A),Result) :- apply_action(A,Result).
