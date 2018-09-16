% gamestate

player_level(1).
zone(factory0).
%findall(m(X,Y,N,L,Hp),monster(X,Y,N,L,Hp),Results).

monster_to_list(monster(X,Y,Name,Level,Id,Hp),[X,Y,Name,Level,Id,Hp]).

monster(X,Y,Name,Level,Id,Hp) :-
				player_level(PlayerLevel),
				zone(Location),
				base_monster([X,Y,Name,LevelAdj,Id,Hp], Location),
				Level is PlayerLevel + LevelAdj.

base_monster(M, factory0) :-
				BaseList =
				% x-coord, y-coord, type, unique-id, level-adjustment, hit-points
				[ [ 1, 4, type4, monster_a, 4, 100]
				, [ 20, 9, floorbot, monster_b, 1, 40]
				, [ 23, 13, floorbot, monster_c, 0, 40 ]
				, [ 19, 11, floorbot, monster_d, 1, 40 ]
				],
				member(M, BaseList).

monster(factory0, 1, 4, type4, monster_a, Level, 100) :- Level is PlayerLevel + 4.
monster(factory0, 20, 9, floorbot, monster_b, Level, 40) :- Level is PlayerLevel + 1.
monster(factory0, 23, 13, floorbot, monster_c, Level, 40) :- Level is PlayerLevel + 0.
monster(factory0, 19, 11, floorbot, monster_d, Level, 40) :- Level is PlayerLevel + 1.
