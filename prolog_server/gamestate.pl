% gamestate

:- use_module(library(http/json_convert)).

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

% initial state

base_player('furious fred', factory0, 0, 0, 1, 100, 'bamboo spatula').

base_monster(factory0, 1, 4, type4, monster_a, 4, 100).
base_monster(factory0, 20, 9, floorbot, monster_b, 1, 40).
base_monster(factory0, 23, 13, floorbot, monster_c, 0, 40).
base_monster(factory0, 19, 11, floorbot, monster_d, 1, 40).
