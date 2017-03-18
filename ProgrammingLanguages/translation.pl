pair(miden, zero).
pair(ena, one).
pair(dio, two).
pair(tria, three).
pair(tessera, four).
pair(pente, five).
pair(eksi, six).
pair(epta, seven).
pair(ochto, eight).
pair(ennia, nine).
pair(deka, ten).
pair(enteka, eleven).
pair(dwdeka, twelve).
pair('deka tria', thirteen).
pair('deka tessera', fourteen).
pair('deka pente', fifteen).
pair('deka eksi', sixteen).
pair('deka epta', seventeen).
pair('deka ochto', eighteen).
pair('deka ennia', nineteen).
pair(eikosi, twenty).
pair(trianta, thirty).
pair(saranta, fourty).
pair(peninta, fifty).
pair(eksinta, sixty).
pair(evdominta, seventy).
pair(ogdonta, eighty).
pair(eneninta, ninety).
pair(ekato, 'a hundred').
pair(ekaton, 'a hundred').
pair(diakosia, 'two hundred').
pair(triakosia, 'three hundred').
pair(tetrakosia, 'four hundred').
pair(pentakosia, 'five hundred').
pair(eksakosia, 'six hundred').
pair(eptakosia, 'seven hundred').
pair(ochtakosia, 'eight hundred').
pair(enniakosia, 'nine hundred').



translate(X, Y):- catch(greek2english(X, Y), E, english2greek(E, X, Y)).

greek2english(X, Y):- atomic_list_concat(NX, ' ', X), remove_spaces(NX, [], NNX), trans(NNX, [], Y).
english2greek(_, X, Y):- atomic_list_concat(NY, ' ', Y), remove_spaces(NY, [], NNY), inv_trans(NNY, [], X).



remove_spaces([], L, Y):- reverse(L, Y).
remove_spaces([X|Xs], Z, Y):- (X = '' -> remove_spaces(Xs, Z, Y)
				;	 remove_spaces(Xs, [X|Z], Y)).



trans([], Y, Z):- reverse(Y, X), atomic_list_concat(X, ' ', Z).
trans([X], L, Y):- pair(X, Z), reverse(NY, [Z|L]), atomic_list_concat(NY, ' ', Y).
trans([X1,X2|Xs], L, Y):- (X1 = deka -> atomic_list_concat([X1, X2], ' ', X), pair(X, Z), trans(Xs, [Z|L], Y)
				;	pair(X1, Z), trans([X2|Xs], [Z|L], Y)).



inv_trans([], Y, Z):- reverse(Y, X), atomic_list_concat(X, ' ', Z).
inv_trans([X], L, Y):- pair(Z, X), reverse(NY, [Z|L]), atomic_list_concat(NY, ' ', Y).
inv_trans([X1,X2|Xs], L, Y):- (X2 = hundred -> ((X1 = a, Xs = []) -> reverse([ekato|L], NY), atomic_list_concat(NY, ' ', Y)
					      ; (X1 = a, Xs \= []) -> inv_trans(Xs, [ekaton|L], Y)
							 ;	atomic_list_concat([X1, X2], ' ', X), pair(Z, X), inv_trans(Xs, [Z|L], Y))
					;      pair(Z, X1), inv_trans([X2|Xs], [Z|L], Y)).

