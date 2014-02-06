% common predicates

% kenken
kenken(N,C,T,1) :- gridsize(N,T).
kenken(N,C,T,2) :- gridsize(N,T), domain(N,T).
kenken(N,C,T,3) :- gridsize(N,T), domain(N,T), distinctgrid(T).

kenken(N,C,T) :- gridsize(N,T), domain(N,T), distinctgrid(N,T), constraints(N,C,T).

% gridsize
gridsize(N,T) :- length(T, N), rowsize(T, N).

rowsize([], _).
rowsize([Row|Tail], N) :- length(Row, N), rowsize(Tail, N).

% domain
domain(_,[]).
domain(N,[Row|Tail]) :- rowrange(N,Row), domain(N,Tail).

rowrange(N,Row) :- integerlist(N,Ints), length(Ints,N), fd_domain(Row, Ints).

integerlist(0,_).
integerlist(N,List) :- nth(N, List, N), Ndec is N-1, integerlist(Ndec, List).

% distinctgrid
distinctgrid(T) :- distinctrows(T), distinctcols(T).

distinctrows([]).
distinctrows([Row|Tail]) :- distinctset(Row), distinctrows(Tail).

distinctcols(T) :- length(T,N), distinctcols(N,T).
distinctcols(0,_).
distinctcols(N,Grid) :- nthcol(N, Grid, Col), distinctset(Col), Ndec is N-1, distinctcols(Ndec,Grid).

ijthsquare(I, J, T, X) :- nth(I, T, Row), nth(J, Row, X).

distinctset([]).
distinctset([H|T]) :- notelem(H,T), distinctset(T).

notelem(_,[]).
notelem(X,[H|T]) :- X #\= H, notelem(X,T).

nthcol(N, Grid, Col) :- length(Grid, I), nthcol(N, Grid, Col, I), length(Col,I).
nthcol(_, _, _, 0).
nthcol(N, Grid, Col, I) :- ijthsquare(I, N, Grid, X), nth(I, Col, X), Idec is I-1, nthcol(N, Grid, Col, Idec).


% predicates beyond this point are untested

% constraints

add(S,L,T) :- add(S,L,T,0).
add(S,[],_,S).
add(S,[H|L],T,Partial) :- H = Hi-Hj, ijthsquare(Hi, Hj, T, Hv), Newpartial is Partial+Hv, add(S,L,T,Newpartial).

multiply(P,L,T) :- multiply(P,L,T,1).
multiply(P,[],_,P).
multiply(P,[H|L],T,Partial) :- H = Hi-Hj, ijthsquare(Hi, Hj, T, Hv), Newpartial is Partial*Hv, multiply(P,L,T,Newpartial).

subtract(D,J,K) :- D is J-K.
subtract(D,J,K) :- D is K-J.

divide(Q,J,K) :- Q is J//K.
divide(Q,J,K) :- Q is K//J.

constraint(+(S,L), T) :- add(S,L,T).
constraint(*(P,L), T) :- multiply(P,L,T).
constraint(-(D,J,K), T) :- J = Ji-Jj, K = Ki-Kj, ijthsquare(Ji, Jj, T, Jv), ijthsquare(Ki, Kj, T, Kv), subtract(D,Jv, Kv).
constraint(/(Q,J,K), T) :- J = Ji-Jj, K = Ki-Kj, ijthsquare(Ji, Jj, T, Jv), ijthsquare(Ki, Kj, T, Kv), divide(Q,Jv, Kv).

constraints(N,[Con|Tail],T) :- constraint(Con, T), constraints(N, Tail, T).
