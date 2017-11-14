entende(s,sim).
entende(y,sim).
entende(sim,sim).
entende(yes,sim).
entende(1,sim).

possivel([]).
qtd([]).

doenca(t1,'Doen�a Inflamat�ria P�lvica (DIP)').
doenca(t2,'Gonorreia').
doenca(t3,'AIDS').
doenca(t4,'Cancro mole').
doenca(t5,'S�filis').
doenca(t6,'Donovanose').
doenca(t7,'Herpes Genitais').
doenca(t8,'Condiloma acuminado').

opcao(q1,'Voc� sente desconforto ou dor no baixo ventre (p� da barriga)').
opcao(q2,'Voc� sente dor durante as rela��es sexuais').
opcao(q3,'Voc� tem febre frequentemente').
opcao(q4,'Voc� apresenta alguma ferida no seu org�o genital').
opcao(q5,'A ferida � dolorosa').
opcao(q6,'Voc� apresenta corrimento').
opcao(q7,'Voc� possui manchas no corpo').
opcao(q8,'Voc� tem perdido peso ou notado uma diminui��o no apetite').
opcao(q9,'Tem apresentado sinais de vermelhid�o na pele').
opcao(q10,'Tem aparecido caro�os na sua virilha ou pesco�o').
opcao(q11,'Tem aparecido verrugas na regi�o do an�s e dos org�os genitais').
opcao(q12,'Voc� apresenta bolhas pequenas agrupadas no seu org�o genital ou ao redor do an�s').
opcao(q13,'A ferida sangra facilmente').



 /* busca a ser testada*/
busca(t1) :- t1, !.
busca(t2) :- t2, !.
busca(t3) :- t3, !.
busca(t4) :- t4, !.
busca(t5) :- t5, !.
busca(t6) :- t6, !.
busca(t7) :- t7, !.
busca(t8) :- t8, !.
busca(unknown):-t9,!. /* sem resposta */

t1:-verificar(q1),porcentagem(t1,possivel(X),qtd(L)),verificar(q2),porcentagem(t1,possivel(X),qtd(L)),verificar(q3),porcentagem(t1,possivel(X),qtd(L)).
t2:-verificar(q1),verificar(q2),verificar(q6).
t3:-verificar(q3),verificar(q8),verificar(q9),verificar(q10).
t4:-verificar(q4),verificar(q5),verificar(q10).
t5:-verificar(q4),verificar(q7).
t6:-verificar(q4),verificar(q13).
t7:-verificar(q6),verificar(q12).
t8:-verificar(q11).
t9:-write('N�o foi possivel identificar uma doen�a sexualmente transmissivel, para mais seguran�a consulte um m�dico!'),fail,!.


perguntar(Pergunta) :-opcao(Pergunta,Q),
        write(Q), write('? '),nl,
         read(Resposta),nl,
         ( entende(Resposta,sim)
         -> assert(yes(Pergunta)) ;
         assert(no(Pergunta)), fail).
:- dynamic yes/1,no/1.
/* Como verificar algo */
verificar(S) :- (yes(S) -> true ; (no(S) -> fail ; perguntar(S))).
/* undo all yes/no assertions */
undo :- retract(yes(_)),fail.
undo :- retract(no(_)),fail.
undo.

insere(E,[E|_],[0|_]).

porcentagem(E,[],[]):- insere(E,[],[]).
porcentagem(E,[T],[R]):- insere(E,[T],[R]).
porcentagem(E,[E|_],[L|_]):- L is L+1.
porcentagem(E,[E],[R]):- R is R+1.

porcentagem(E,[_|T],[_|R]):- porcentagem(E,[T],[R]).

printList([]).
printList([H|T]):-write(H),printList([T]).


identificar :- write('--*--Ol�, vou te auxiliar a identificar se voc� possui alguma DST--*--')
		,nl,nl, busca(DST),
       write('Eu acho que a doen�a �: '),doenca(DST,X),
       write(X), nl, undo.
