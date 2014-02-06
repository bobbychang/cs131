% common predicates
ijthsquare(I, J, T, X) :- nth(I, T, Row), nth(J, Row, X).

% kenken
kenken(1, N, T) :- gridsize(N,T).
kenken(2, N, T) :- gridsize(N,T), domain(N,T).

kenken(N,C,T) :- gridsize(N,T), domain(N,T), distinctgrid(N,T), constraints(N,C,T).

% gridsize
gridsize(N,T) :- length(T, N), rowsize(T, N).

rowsize([], _).
rowsize([Row|Tail], N) :- length(Row, N), rowsize(Tail, N).

% domain
domain(_,[]).
domain(N,[Row|Tail]) :- rowrange(N,Row), domain(N,Tail).

rowrange(N,Row) :- length(List,N), integerlist(N,List), fd_domain(Row, List).

integerlist(0,_).
integerlist(N,List) :- nth(N, List, N), Ndec is N-1, integerlist(Ndec, List).

% distinctgrid
distinctgrid(N,T) :- distinctrows(T), distinctcols(T,N).

distinctrows([]).
distinctrows([Row|Tail]) :- distinctset(Row), distinctrows(Tail).

distinctcols(_, 0).
distinctcols(Grid, N) :- nthcol(N, Grid, Col), distinctset(Col), Ndec is N-1, distinctcols(Grid, Ndec).

nthcol(N, Grid, Col) :- length(Grid, I), nthcol(N, Grid, Col, I).
nthcol(_, _, _, 0).
nthcol(N, Grid, Col, I) :- nth(I, Col, X), ijthsquare(I, N, Grid, X), Idec = I-1, nthcol(N, Grid, Col, Idec).

% constraints
constraints(N,[Rule|Tail],T) :- constraint(Rule, T), rules(N, Tail, T).

constraint(+(S,L), T) :- true. 

constraint(*(P,L), T) :- true.

constraint(-(D,J,K), T) :- J = Ji-Jj, K = Ki-Kj, ijthsquare(Ji, Jj, T, Jv), ijthsquare(Ki, Kj, T, Kv), subtract(D,Jv, Kv).
subtract(D,J,K) :- D is J/K.
subtract(D,J,K) :- D is K/J.

followsrule(//(Q,J,K), T) :- J = Ji-Jj, K = Ki-Kj, ijthsquare(Ji, Jj, T, Jv), ijthsquare(Ki, Kj, T, Kv), divide(Q,Jv, Kv).
divide(Q,J,K) :- Q is J/K.
divide(Q,J,K) :- Q is K/J.

