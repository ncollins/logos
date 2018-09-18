:- use_module(library(http/http_session)).

% initalize

initialize_game(true) :-
		http_session_retractall(player(_Name, _Zone, _X, _Y, _Lvl, _Hp, _Weapon)),
		base_player(Name, Zone, X, Y, Lvl, Hp, Weapon),
		http_session_assert(active_player(Name, Zone, X, Y, Lvl, Hp, Weapon)),
		initialize(Zone).

base_monster_with_level(Zone,X,Y,Kind,Id,L,HP) :-
	base_monster(Zone,X,Y,Kind,Id,LevelAdj,HP),
	http_session_data(active_player(_N,_Z,_X,_Y,PlayerLevel,_H,_W)),
	L is PlayerLevel + LevelAdj.

initialize(Zone) :-
	http_session_retractall(alive_monster(_,_,_,_,_,_,_)),
	findall(alive_monster(Zone,X,Y,Kind,Id,Level,HP),base_monster_with_level(Zone,X,Y,Kind,Id,Level,HP),Monsters),
	maplist(http_session_assert,Monsters).


% player updates

rename_player(NewName) :-
	http_session_data(active_player(_Name, Zone, X, Y, Lvl, Hp, Weapon)),
	http_session_retractall(active_player(_N,_Z,_X,_Y,_L,_H,_W)),
	http_session_assert(active_player(NewName, Zone, X, Y, Lvl, Hp, Weapon)).

update_player(Name, Zone, X, Y, Lvl, Hp, Weapon) :-
  http_session_retractall(active_player(_Name, _Zone, _, _Y, _Lvl, _Hp, _Weapon)),%%
  http_session_assert(active_player(Name, Zone, X, Y, Lvl, Hp, Weapon)).

% queries

all_alive_monsters(AliveMonsters) :-
	findall(alive_monster(Zone,X,Y,Kind,Id,Level,HP),http_session_data(alive_monster(Zone,X,Y,Kind,Id,Level,HP)),AliveMonsters).

query_player(player(Name,Zone,X,Y,Lvl,Hp,Weapon)) :-
	http_session_data(active_player(Name, Zone, X, Y, Lvl, Hp, Weapon)).
