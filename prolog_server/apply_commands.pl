% updates

:- ensure_loaded([game_state]).

% APPLY ACTIONS ----------------------------------------

coord_shift(dir(north,C),shift(0,Y)) :- Y is -C.
coord_shift(dir(south,C),shift(0,Y)) :- Y is C.
coord_shift(dir(east,C),shift(X,0)) :- X is C.
coord_shift(dir(west,C),shift(X,0)) :- X is -C.

coord_at(coord(OldX,OldY),dir(D,C),coord(NewX,NewY)) :-
  coord_shift(dir(D,C),shift(ShiftX,ShiftY)),
  NewX is max(min(OldX + ShiftX, 16), 0),
  NewY is max(min(OldY + ShiftY, 23), 0).

apply_action(go(dir(D,C))) :-
  query_player(player(Name, Zone, OldX, OldY, Lvl, Hp, Weapon)),
  coord_at(coord(OldX,OldY),dir(D,C),coord(NewX,NewY)),
  update_player(Name,Zone,NewX,NewY,Lvl,Hp,Weapon).

%apply_action(attack(dir(D))) :- true.

apply_action_list([]).
apply_action_list([H|T]) :- apply_action(H), apply_action_list(T).
