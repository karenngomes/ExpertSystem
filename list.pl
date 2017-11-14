entende(s,sim).
entende(y,sim).
entende(sim,sim).
entende(yes,sim).
entende(1,sim).

possivel([]).
qtd([]).

doenca(t1,'Doença Inflamatória Pélvica (DIP)').
doenca(t2,'Gonorreia').
doenca(t3,'AIDS').
doenca(t4,'Cancro mole').
doenca(t5,'Sífilis').
doenca(t6,'Donovanose').
doenca(t7,'Herpes Genitais').
doenca(t8,'Condiloma acuminado').

opcao(q1,'Você sente desconforto ou dor no baixo ventre (pé da barriga)').
opcao(q2,'Você sente dor durante as relações sexuais').
opcao(q3,'Você tem febre frequentemente').
opcao(q4,'Você apresenta alguma ferida no seu orgão genital').
opcao(q5,'A ferida é dolorosa').
opcao(q6,'Você apresenta corrimento').
opcao(q7,'Você possui manchas no corpo').
opcao(q8,'Você tem perdido peso ou notado uma diminuição no apetite').
opcao(q9,'Tem apresentado sinais de vermelhidão na pele').
opcao(q10,'Tem aparecido caroços na sua virilha ou pescoço').
opcao(q11,'Tem aparecido verrugas na região do anûs e dos orgãos genitais').
opcao(q12,'Você apresenta bolhas pequenas agrupadas no seu orgão genital ou ao redor do anûs').
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
t9:-write('Não foi possivel identificar uma doença sexualmente transmissivel, para mais segurança consulte um médico!'),fail,!.


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


identificar :- write('--*--Olá, vou te auxiliar a identificar se você possui alguma DST--*--')
		,nl,nl, busca(DST),
       write('Eu acho que a doença é: '),doenca(DST,X),
       write(X), nl, undo.
