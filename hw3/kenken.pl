% kenken
kenken(N,C,T) :- gridsize(N,T), domain(N,T), distinctgrid(N,T), constraints(C,T), resolvegrid(T).

plain_kenken(N,C,T) :- gridsize(N,T), plain_domain(N,T), distinctgrid(N,T), constraints(C,T).

% gridsize
gridsize(N,T) :- length(T, N), rowsize(N,T).

rowsize(_, []).
rowsize(N,[Row|Tail]) :- length(Row, N), rowsize(N,Tail).

% domain
domain(N,T) :- integerlist(N,Ints), length(Ints,N), domain(T,Ints).

domain([],_).
domain([Row|Tail],Ints) :- rowrange(Row,Ints), domain(Tail,Ints).

rowrange(Row,Ints) :- fd_domain(Row, Ints).

integerlist(0,_).
integerlist(N,List) :- nth(N, List, N), Ndec is N-1, integerlist(Ndec, List).

% distinctgrid
distinctgrid(N,T) :- distinctrows(T), distinctcols(N,T).

distinctrows([]).
distinctrows([Row|Tail]) :- distinctset(Row), distinctrows(Tail).

distinctcols(0,_).
distinctcols(N,Grid) :- nthcol(N, Grid, Col), distinctset(Col), Ndec is N-1, distinctcols(Ndec,Grid).

ijthsquare(I-J,T,X) :- nth(I, T, Row), nth(J, Row, X).
ijthsquare(I,J,T,X) :- nth(I, T, Row), nth(J, Row, X).

distinctset([]).
distinctset([H|T]) :- notelem(H,T), distinctset(T).

notelem(_,[]).
notelem(X,[H|T]) :- fd_var(X), X #\= H, notelem(X,T).
notelem(X,[H|T]) :- non_fd_var(X), X \= H, notelem(X,T).

nthcol(N, Grid, Col) :- length(Grid, I), nthcol(N, Grid, Col, I), length(Col,I).
nthcol(_, _, _, 0).
nthcol(N, Grid, Col, I) :- ijthsquare(I, N, Grid, X), nth(I, Col, X), Idec is I-1, nthcol(N, Grid, Col, Idec).

% constraints
constraints([],_).
constraints([Con|Tail],T) :- constraint(Con,T), constraints(Tail, T).

constraint(+(S,L), T) :- add(S,L,T).
constraint(*(P,L), T) :- multiply(P,L,T).

constraint(-(D,J,K), T) :- ijthsquare(J, T, Jv), ijthsquare(K, T, Kv), subtract(D,Jv,Kv).
constraint(/(Q,J,K), T) :- ijthsquare(J, T, Jv), ijthsquare(K, T, Kv), divide(Q,Jv,Kv).

add(S,L,T) :- add(S,L,T,0).
add(S,[],_,S).
add(S,[H|L],T,Partial) :- ijthsquare(H, T, Hv), fd_var(Hv), Newpartial #= Partial+Hv, add(S,L,T,Newpartial).
add(S,[H|L],T,Partial) :- ijthsquare(H, T, Hv), non_fd_var(Hv), Newpartial is Partial+Hv, add(S,L,T,Newpartial).

multiply(P,L,T) :- multiply(P,L,T,1).
multiply(P,[],_,P).
multiply(P,[H|L],T,Partial) :- ijthsquare(H, T, Hv), fd_var(Hv), Newpartial #= Partial*Hv, multiply(P,L,T,Newpartial).
multiply(P,[H|L],T,Partial) :- ijthsquare(H, T, Hv), non_fd_var(Hv), Newpartial is Partial*Hv, multiply(P,L,T,Newpartial).

subtract(D,J,K) :- fd_var(J), fd_var(K), D #= J-K.
subtract(D,J,K) :- fd_var(J), fd_var(K), D #= K-J.
subtract(D,J,K) :- non_fd_var(J), non_fd_var(K), D is J-K.
subtract(D,J,K) :- non_fd_var(J), non_fd_var(K), D is K-J.

divide(Q,J,K) :- fd_var(J), fd_var(K), Qf #= Q/1, Qf #= J/K.
divide(Q,J,K) :- fd_var(J), fd_var(K), Qf #= Q/1, Qf #= K/J.
divide(Q,J,K) :- non_fd_var(J), non_fd_var(K), Qf is Q/1, Qf is J/K.
divide(Q,J,K) :- non_fd_var(J), non_fd_var(K), Qf is Q/1, Qf is K/J.

% resolve
resolvegrid([]).
resolvegrid([Th|Tt]) :- resolverow(Th), resolvegrid(Tt).

resolverow([]).
resolverow([Th|Tt]) :- resolve(Th), resolverow(Tt).

resolve(Nfd) :- non_fd_var(Nfd).
resolve(Fd) :- fd_var(Fd), fd_dom(Fd, Dom), resolve(Dom, Fd).
resolve([H|T],Fd) :- Fd #= H.
resolve([H|T],Fd) :- resolve(T,Fd).

% plain_domain
plain_domain(N,T) :- integerlist(N,Ints), length(Ints,N), plain_domain(T,Ints).

plain_domain([],_).
plain_domain([Row|Tail],Ints) :- plain_rowrange(Row,Ints), plain_domain(Tail,Ints).

plain_rowrange([],_).
plain_rowrange([Cell|Tail],Ints) :- member(Cell,Ints), plain_rowrange(Tail, Ints).

% tests
kenken(N,C,T,1) :- gridsize(N,T).
kenken(N,C,T,2) :- gridsize(N,T), domain(N,T).
kenken(N,C,T,3) :- gridsize(N,T), domain(N,T), distinctgrid(N,T).
kenken(N,C,T,4) :- gridsize(N,T), domain(N,T), distinctgrid(N,T), constraints(C,T).

plain_kenken(N,C,T,1) :- gridsize(N,T).
plain_kenken(N,C,T,2) :- gridsize(N,T), plain_domain(N,T).
plain_kenken(N,C,T,3) :- gridsize(N,T), plain_domain(N,T), distinctgrid(N,T).
plain_kenken(N,C,T,4) :- gridsize(N,T), plain_domain(N,T), distinctgrid(N,T), constraints(C,T).
