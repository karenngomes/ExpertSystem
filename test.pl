:- dynamic probabilidade/2.

probabilidade(t1,0).
asserta(probabilidade(t2,3)).

increment(X):- probabilidade(X,Y), Y is Y+1, retract(probabilidade(X,_)), asserta(probabilidade(X,Y1)). 

