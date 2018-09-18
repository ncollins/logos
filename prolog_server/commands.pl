% commands

% DCG (difference list) style

command(action_list(L))  --> action_list(L).
command(rename(A)) --> rename(A).
command(info) --> info.
command(help) --> help.

command(reset) --> [reset].
command(reset) --> [start].
command(reset) --> [restart].

info --> [info].
help --> [help].

% meta actions

rename(Name) --> [ my, name, is, Name ].

% game actions ----------------------------

action_list([H|T]) --> action(H), and, action_list(T).
action_list([H]) --> action(H).

action(go(dir(D,C))) --> go(dir(D,C)).
action(attack(dir(D))) --> attack(dir(D)).

and --> [and].

attack(dir(D)) --> attack_word, direction(D).

attack_word --> [ attack ].
attack_word --> [ hit ].

go(dir(D,C)) --> movement, direction(D), count(C).
go(dir(D,C)) --> movement, count(C), direction(D).

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
