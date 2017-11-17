:- include('dados.pl').

 /* busca a ser testada*/
busca(t1) :- perguntar([q1,q6,q2,q3,q4,q8,q9,q10,q11,q12,q13,q14,q15,q16]), 
	gerarPorcentagens([t1,t2,t3,t4,t5,t6],G), G > 0 , porcentagem(X,_), porcentagemGeral(X,G).
busca(t1) :- write('Nao foi possivel identificar nenhuma doenca com as informacoes fornecidas!'),nl.
busca(t2) :- perguntar([q5,q7,q2,q3,q4,q8,q9,q10,q11,q12,q13,q14,q15,q16]),
	gerarPorcentagens([t2,t3,t4,t5,t6],G), G > 0, porcentagem(X,_), porcentagemGeral(X,G).
busca(t2) :- write('Nao foi possivel identificar nenhuma doenca com as informacoes fornecidas!'),nl.

perguntar([]).
perguntar([H|T]) :- perguntas(H,Q,S),
        write(Q), write('? '),nl,
         read(Resposta),nl,
         (entende(Resposta,sim) -> increment(S), perguntar(T) ; perguntar(T)).

verificar([]).
verificar([H|T]) :- perguntar(H), verificar(T).

undo :- retract(probabilidade(_,_)), retract(porcentagem(_,_)),fail.
undo :- init([t1,t2,t3,t4,t5,t6]).

inicio :- write('Voce e mulher?'),nl, read(Resposta), nl, 
    (entende(Resposta,sim) 
	-> busca(t1) ; busca(t2)
    ).

identificar :- write('--*--Ola, vou te auxiliar a identificar se você possui alguma DST --*--')
	   ,nl, nl, inicio, undo.
