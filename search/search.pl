% Initialize explorer with starting position and empty bag
initiate_journey(explorer(Position, Bag)) :-
    initial(Position),
    Bag = [].

% Handle moving through regular doors (bidirectional)
advance(explorer(Current, Bag), move(Current, Next), explorer(Next, Bag)) :-
    door(Current, Next).
advance(explorer(Current, Bag), move(Current, Next), explorer(Next, Bag)) :-
    door(Next, Current).

% Handle collecting keys when entering a room
advance(explorer(Current, Bag), move(Current, Next), explorer(Next, UpdatedBag)) :-
    (door(Current, Next) ; door(Next, Current)),
    key(Next, Key),
    \+ member(Key, Bag),
    UpdatedBag = [Key|Bag].

% Handle locked doors (bidirectional)
advance(explorer(Current, Bag), move(Current, Next), explorer(Next, Bag)) :-
    locked_door(Current, Next, Key),
    member(Key, Bag).
advance(explorer(Current, Bag), move(Current, Next), explorer(Next, Bag)) :-
    locked_door(Next, Current, Key),
    member(Key, Bag).

% Check if we've reached the treasure
goal_reached(explorer(Position, _)) :-
    treasure(Position).

% Process a single move
journey_step(Start, [Move], Result) :-
    advance(Start, Move, Result).

% Process multiple moves
journey_step(Start, [Move | RestActions], End) :-
    advance(Start, Move, MidPoint),
    journey_step(MidPoint, RestActions, End).

% Main search predicate
search(Actions) :-
    initiate_journey(Start),
    length(Actions, _),  % Generate potential path lengths
    journey_step(Start, Actions, End),
    goal_reached(End),
    !.  % Cut to prevent backtracking once solution is found