:- use_module(library(http/thread_httpd)).

:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_path)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_wrapper)).

:- use_module(library(http/html_write)).
:- use_module(library(http/json_convert)).

:- ensure_loaded([commands]).
:- ensure_loaded([apply_commands]).
:- ensure_loaded([game_state]).
:- ensure_loaded([game_config]).


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
				apply_command(Parsed,GameState),
				game_state_to_json(GameState,Json),
				reply_json_dict(Json).

% get JSON output

:- json_object
				json_alive_monster(area:string, x:integer, y:integer, kind:string, id:string, level:integer, hp:integer)  + [type=monster].

:- json_object
				json_player(name:string, zone:string, x:integer, y:integer, level:integer, hp:integer, weapon:string) + [type=player].

player_to_json(player(Name, Zone, X, Y, Lvl, Hp, Weapon),JSON) :-
	atom_string(Name,NameS),
	atom_string(Zone,ZoneS),
	atom_string(Weapon,WeaponS),
	prolog_to_json(json_player(NameS,ZoneS,X,Y,Lvl,Hp,WeaponS),JSON).

alive_to_json(alive_monster(Loc,X,Y,Kind,Id,L,HP),JSON) :-
	atom_string(Loc,LocS),
	atom_string(Kind,KindS),
	atom_string(Id,IdS),
	prolog_to_json(json_alive_monster(LocS,X,Y,KindS,IdS,L,HP),JSON).

game_state_to_json(state(Player,AliveMonsters,Messages),JSON) :-
	maplist(alive_to_json,AliveMonsters,JsonMonsters),
	player_to_json(Player,JsonPlayer),
  prolog_to_json(Messages, JsonMessages),
	JSON = json([player=JsonPlayer, alive_monsters=JsonMonsters, messages=JsonMessages]).
