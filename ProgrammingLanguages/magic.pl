create(X, 0, X).
create([], N, X):- N > 0, NewN is N-1, create([1], NewN, X).
create([Y|Ys], N, X):- N > 0, NewN is N-1, append([Y|Ys], [0], NY), create(NY, NewN, X).



pow([], _, 0).
pow([X|Xs], B, Pol):- pow(Xs, B, NPol), Pol is NPol*B + X.





compute_h([], _, Acc, _, Acc).
compute_h([X|Y], B, Acc, Pow, Res) :-
   NewPow is Pow*B,
   NewAcc is Acc+Pow*X,
   compute_h(Y, B, NewAcc, NewPow, Res).

compute(B, L, Num) :- compute_h(L, B, 0, 1, Num).





quicksort([], []).
quicksort([HEAD | TAIL], SORTED) :- partition(HEAD, TAIL, LEFT, RIGHT),
                                    quicksort(LEFT, SORTEDL),
                                    quicksort(RIGHT, SORTEDR),
                                    append(SORTEDL, [HEAD | SORTEDR], SORTED).



partition(_, [], [], []).
partition(PIVOT, [HEAD | TAIL], [HEAD | LEFT], RIGHT) :- HEAD @> PIVOT,
                                                         partition(PIVOT, TAIL, LEFT, RIGHT).
partition(PIVOT, [HEAD | TAIL], LEFT, [HEAD | RIGHT]) :- HEAD @=< PIVOT,
                                                         partition(PIVOT, TAIL, LEFT, RIGHT).



apply([_|Xs],1, N, [Z|Zs]):- Z = N, Xs = Zs.
apply([X|Xs], I, N, [Z|Zs]):- I > 1, Z = X, NewI is I-1, apply(Xs, NewI, N, Zs).




substract([], [], _, _, []).
substract([X|Xs], [Y|Ys], B, Curry, [Z|Zs]):-
(X > Y -> Z is X-Y-Curry, substract(Xs, Ys, B, 0, Zs)
        ; X = Y -> (Curry = 0 -> Z = 0, substract(Xs, Ys, B, 0, Zs)
                               ; Z is B-1, substract(Xs, Ys, B, 1, Zs))
                 ; Z is X-Y+B-Curry, substract(Xs, Ys, B, 1, Zs)).
substract([], Y, B, Curry, Z):- Y \= [], reverse(Y, X), substract(X, Y, B, Curry, Z).




next_number([Num|Nums], 1, B, _, NextI, Next):- 
(Num < B-1 -> New is Num+1, append([New], Nums, Next), NextI = 2
            ; Next = [], NextI = 0).
next_number(Numbers, I, B, N, NextI, Next):-
NewI is I-1, (I =:= N // 2 + 1 -> next_number(Numbers, NewI, B, N, NextI, Next)
                                 ; nth1(I, Numbers, K), nth1(NewI, Numbers, L),
                                   (K < L -> NewK is K+1, apply(Numbers, I, NewK, Next), NextI is I+1
                                           ; apply(Numbers, I, 0, NewNum), next_number(NewNum, NewI, B, N, NextI, Next))).




find([], _, _, 0, []).
find(Num, B, _, _, M):- Num \= [], substract([], Num, B, 0, TheNumber), quicksort(TheNumber, Sorted), substract([], Sorted, B, 0, L), TheNumber = L, M = L.
find(Num, B, N, Pos, M):- Num \=[], next_number(Num, Pos, B, N, NPos, Next), find(Next, B, N, NPos, M).




magic(B, N, Magic):- create([], N, Start), once(find(Start, B, N, 2, L)), L \= [], compute(B, L, Magic).
