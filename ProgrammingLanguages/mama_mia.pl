min([],[]).
min([X|_], X).


quicksort([], []).
quicksort([HEAD | TAIL], SORTED) :- partition(HEAD, TAIL, LEFT, RIGHT),
                                    quicksort(LEFT, SORTEDL),
                                    quicksort(RIGHT, SORTEDR),
                                    append(SORTEDL, [HEAD | SORTEDR], SORTED).


partition(_, [], [], []).
partition(PIVOT, [HEAD | TAIL], [HEAD | LEFT], RIGHT) :- HEAD @=< PIVOT,
                                                         partition(PIVOT, TAIL, LEFT, RIGHT).
partition(PIVOT, [HEAD | TAIL], LEFT, [HEAD | RIGHT]) :- HEAD @> PIVOT,
                                                         partition(PIVOT, TAIL, LEFT, RIGHT).



minlength([], X, X).
minlength([X|Xs], MIN, Y):- length(X, K), ((K @< MIN) -> minlength(Xs, K, Y)
                           ; minlength(Xs, MIN, Y)).
   


find_min([], X, X).
find_min([X|Xs], [], Z):-find_min(Xs, [X], Z).
find_min([X|Xs], [Y|Ys], Z):- add(X, 0, L), add(Y, 0, Min),
                                 (L @< Min -> find_min(Xs, [X], Z)
                                 ;L @> Min -> find_min(Xs, [Y|Ys], Z)
                                 ;append([X],[Y|Ys],NewY), find_min(Xs, NewY, Z)).





add([], X, X).
add([(N,_)|Xs], Y, Z):- NewY is Y+N, add(Xs, NewY, Z).



puta(X, 0, _, X).
puta(X, N, A, Y):- N > 0, NewN is N-1, append([A], X, Z), puta(Z, NewN, A, Y).




encode([],A,K,[(K,A)]).
encode([(N,A)|XS],A,K,Z):- NewN is N+K, append([(NewN,A)], XS, Z).
encode([(N,X)|XS],A,K,Z):- X \= A, append([(K,A)], [(N,X)|XS], Z).



decode([], X, X).
decode([(N,X)|XS], Y, Z):- puta([], N, X, XX), append(XX, Y, NewY), decode(XS, NewY, Z).
 


find_mama(Y, _, _, Li, Hi, Lo, Ho, Ans):- Li>= Lo, Ho>= Hi, Ans = [Y].
find_mama(Y, A, M, Li, Hi, Lo, Ho, Ans):- Ho > Hi, Lo > Li, Ho - Lo >= Hi - Li,
M*(Hi - Li) > (Ho - Lo), Ho - Hi >= Lo - Li, D is Lo - Li, K is (D // A), (D mod A =:= 0 -> Ho >= Hi + K*A, encode(Y, 'A', K, Res), Ans = [Res]
                                                                                            ; Ho >= Hi + (K+1)*A, NK is K+1, encode(Y, 'A', NK, Res), Ans = [Res]).
find_mama(Y, A, M, Li, Hi, Lo, Ho, Ans):-
Ho > Hi, Lo > Li, Hi-Li =< Ho - Lo, NewLi is Li*M, NewHi is Hi*M, encode(Y, 'M', 1, NewY), (find_mama(NewY, A, M, NewLi, NewHi, Lo, Ho, NAns)-> OAns = NAns
                                                                                                                                             ; OAns = []), 
NNewLi is Li + A, NNewHi is Hi + A, encode(Y, 'A', 1, NNewY), (find_mama(NNewY, A, M, NNewLi, NNewHi, Lo, Ho, NNAns)-> OOAns = NNAns
                                                                                                                   ; OOAns = []), append(OAns, OOAns, Ans).





mama_mia(_, M, Li, Hi, Lo, Ho, Prog):- M = 1, Ho >= Hi, Li >= Lo, Prog = ''.
mama_mia(A, M, Li, Hi, Lo, Ho, Prog):- M = 1, Ho > Hi, Lo > Li, Ho - Lo >= Hi - Li, D is Lo - Li, K is (D // A), (D mod A =:= 0 -> Ho >= Hi + K*A, puta([], K, 'A', Z), atom_chars(Prog, Z)
                                                                                                                         ; Ho >= Hi + (K+1)*A, NK is K+1, puta([], NK, 'A', Z), atom_chars(Prog, Z)).
mama_mia(A, M, Li, Hi, Lo, Ho, Prog):- M > 1, once(find_mama([], A, M, Li, Hi, Lo, Ho, L)), L \= [],  find_min(L, [], Min), makestring(Min, NewL),
                                       quicksort(NewL, Sorted), min(Sorted, Prog).





makestring([], []).
makestring([X|Xs], [Y|Ys]):-decode(X, [], NX), atom_chars(Y, NX), makestring(Xs, Ys).
