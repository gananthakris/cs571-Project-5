% Base case: The treasure is found.
search([Room]) :-
    treasure(Room).

% Recursive case: Expand paths and search for the treasure.
search(Path) :-
    start(StartRoom),
    bfs([[StartRoom]], Path).

% Breadth-first search to find the shortest path.
bfs([[Room | Path] | _], [Room | Path]) :-
    treasure(Room).

bfs([[Room | Path] | Rest], Solution) :-
    findall(
        [NextRoom, Room | Path],
        (door(Room, NextRoom),
         \+ member(NextRoom, [Room | Path]),
         is_accessible(Room, NextRoom)),
        NewPaths),
    append(Rest, NewPaths, UpdatedPaths),
    bfs(UpdatedPaths, Solution).

% Check if a move is accessible (key collected if needed).
is_accessible(CurrentRoom, NextRoom) :-
    \+ locked(CurrentRoom, NextRoom); % No lock or
    (locked(CurrentRoom, NextRoom),
     key_required(CurrentRoom, NextRoom, Key),
     has_key(Key)).

% Check if a door is locked.
locked(_, Room2) :-
    key(Room2, _).

% Check which key is required to unlock a door.
key_required(_, Room2, Key) :-
    key(Room2, Key).

% Check if the key is already collected.
has_key(Key) :-
    collected_keys(Keys),
    member(Key, Keys).

% Collected keys (for dynamic tracking, modify as needed).
collected_keys([]).