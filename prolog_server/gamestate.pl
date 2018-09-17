% gamestate

:- use_module(library(http/json_convert)).

:- json_object
				json_alive_monster(area:string, x:integer, y:integer, kind:string, id:string, level:integer, hp:integer)  + [type=monster].

alive_to_json(alive_monster(Loc,X,Y,Kind,Id,L,HP),JSON) :-
	atom_string(Loc,LocS),
	atom_string(Kind,KindS),
	atom_string(Id,IdS),
	prolog_to_json(json_alive_monster(LocS,X,Y,KindS,IdS,L,HP),JSON).

% initial state

base_monster(factory0, 1, 4, type4, monster_a, 4, 100).
base_monster(factory0, 20, 9, floorbot, monster_b, 1, 40).
base_monster(factory0, 23, 13, floorbot, monster_c, 0, 40).
base_monster(factory0, 19, 11, floorbot, monster_d, 1, 40).
