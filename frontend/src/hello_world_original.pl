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
:- http_handler(root(.), http_reply_file('site/index.html', []), []).		% (1)
:- http_handler(images(.), serve_files_in_directory(images), [prefix]).
:- http_handler(third(.), serve_files_in_directory(third), [prefix]).
:- http_handler(lib(.), serve_files_in_directory(lib), [prefix]).


% PROLOG API

:- http_handler(root(hello_world), say_hi, []).		% (1)
:- http_handler(root(command), command, []).		% (1)
:- http_handler(root(echo), echo, []).		% (1)

server(Port) :-						% (2)
				http_server(http_dispatch, [port(Port)]).

say_hi(_Request) :-					% (3)
				%format('Content-type: text/plain~n~n'),
				%format('Hello World!~n').
				reply_html_page(title('Hello, world, Prolog!'),
				[ h1('This is in an h1 tag'),
				div('Div div div'),
				%\say_what(Request)
				\say_what
				]).

command(Request) :-
				http_read_json_dict(Request, Parameters),
				get_dict(command, Parameters, RawCommand),
				split_string(RawCommand," ","",CommandStrings),
				maplist(atom_string,Command,CommandStrings),
				command(Parsed,Command,[]),
				apply_command(Parsed,Result),
				prolog_to_json(Result,Json),
				reply_json_dict(Json).

echo(Request) :-
				http_read_json_dict(Request, Parameters),
				reply_json_dict(Parameters).




who(yuki, scientist).
who(sam, ninja).
who(_, 'unknown person').

% syntactic sugar for:
%
% say_what(A, B, E) :-
% who(A, C),
% D=B,
% html(div([A, is, a, C]), D, E).
%
%say_what(Request) -->
%				{ %http_current_request(Request),
say_what --> 
{ http_current_request(Request), 
http_parameters(Request, [name(Person, [])], []),
who(Person,Job)
}, 
html(div([Person, ' is ', ' a ', ' wicked ', Job])).

% [1]  ?- get_dict(x,r{x:1, y:2},V).
% V = 1.
% 
% [1]  ?- put_dict(z,r{x:1, y:2},10,D).
% D = r{x:1, y:2, z:10}.
