% commands

command(action(A)) --> action(A).
command(rename(A)) --> rename(A).
command(info) --> info.
command(help) --> help.

command(reset) --> [reset].
command(reset) --> [start].
command(reset) --> [restart].

info --> [info].

help --> [help].

% DCG (difference list) style

location(home).
location(office).

% go(A, B, D) :-
%	 location(A),
%	 C=B,
%	 C=[go, to, A|D].

action(go(Location)) --> go(Location).
%action(attack(Enemy)) --> attack(Enemy).

go(named(Location)) --> { location(Location) }, [go, to, Location].

%go(dir(D,C)) --> { direction(D), count(C) }, [ move, D, C ].
go(dir(D,C)) --> movement, direction(D), count(C).

movement --> [ move ].

direction(north) --> [ north ].
direction(north) --> [ up ].
direction(south) --> [ south ].
direction(south) --> [ down ].
direction(east) --> [ east ].
direction(east) --> [ right ].
direction(west) --> [ west ].
direction(west) --> [ left ].

count(N,[X|Rest],Rest) :-
  atom_number(X,N),
  integer(N).


%go(square(X,Y)) --> { sq(Sq,X,Y) }, [go, to, square, Sq].

%attack(Enemy) --> { enemy(Enemy) }, [attack, Enemy].
%attack(Enemy) --> { enemy(Enemy) }, [fight, Enemy].

rename(Name) --> [ my, name, is, Name ].

%go --> [go, to, fred_house].


%sq(Sq,X,Y) :-
%string_chars(Sq,[XChar,YChar]),
%string_chars(XStr,[XChar]),
%string_chars(YStr,[YChar]),
%atom_string(X,XStr),
%number_string(Y,YStr).

%apply_action(go(named(home)),[1, 2, 3, 4]) :- !.
%apply_action(_,"do nothing").

% r{highlighted = [], enemies=[]}
