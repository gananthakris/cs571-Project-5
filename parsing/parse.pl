parse(Input) :- parse_lines(Input, []).

parse_lines([], []).
parse_lines([D|Rest], FinalRest) :-
    parse_line([D|Rest], Rest1),
    parse_lines_rest(Rest1, FinalRest).

parse_lines_rest([';'|Rest], FinalRest) :- parse_lines(Rest, FinalRest).
parse_lines_rest([], []).

parse_line([D|Rest], FinalRest) :-
    digit(D),
    parse_num(Rest, Rest1),
    parse_line_rest(Rest1, FinalRest).

parse_line_rest([','|Rest], FinalRest) :- parse_line(Rest, FinalRest).
parse_line_rest(Rest, Rest).

parse_num([], []).
parse_num([D|Rest], FinalRest) :-
    (digit(D) -> parse_num(Rest, FinalRest); FinalRest = [D|Rest]).

digit('0'). digit('1'). digit('2'). digit('3'). digit('4').
digit('5'). digit('6'). digit('7'). digit('8'). digit('9').