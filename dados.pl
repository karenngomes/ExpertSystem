:- dynamic probabilidade/2.
:- dynamic porcentagem/2.
:- encoding(utf8).

probabilidade(t1,0).
probabilidade(t2,0).
probabilidade(t3,0).
probabilidade(t4,0).
probabilidade(t5,0).
probabilidade(t6,0).

entende(s,sim).
entende(y,sim).
entende(sim,sim).
entende(yes,sim).
entende(1,sim).

doenca(t1,'Doença Inflamatoria Pélvica (DIP)').
doenca(t2,'Gonorreia').
doenca(t3,'AIDS').
doenca(t4,'Cancro mole').
doenca(t5,'Sífilis').
doenca(t6,'Herpes Genitais').

perguntas(q1,'Voce tem tido corrimento vaginal e odor desagradavel?',[t1,t2]). /* DIP, Gonorreia - M */
perguntas(q2,'Voce tem febre frequentemente',[t1,t2,t3,t4]). /* DIP, Gonorreia, AIDS, Cancro Mole */
perguntas(q3,'Voce sente dores durante a relação sexual',[t1,t4]). /* DIP, Cancro mole */
perguntas(q4,'Voce tem tido dor ou ardencia ao urinar?',[t2,t6]). /* Gonorreia, Herpes */
perguntas(q5,'Voce tem tido secreção abundante de pus pela uretra',[t2]). /* Gonorreia - H */
perguntas(q6,'Voce tem tido sangramentos fora do periodo menstrual',[t2]). /* Gonorreia - M */
perguntas(q7,'Dor ou inchaço em um dos testiculos',[t2]). /* Gonorreia - H */
perguntas(q8,'Voce tem tido nausea e vomitos',[t1]). /* DIP */
perguntas(q9,'Voce tem perdido peso rapidamente ou notado uma diminuição no apetite',[t3,t5]). /* AIDS, Sifilis */
perguntas(q10,'Tosse seca prolongada e garganta arranhada',[t3]). /* AIDS */
perguntas(q11,'Voce possui manchas avermelhadas ou pequenas bolinhas vermelhas na pele',[t3,t5,t6]). /* AIDS, Sifilis, Herpes */
perguntas(q12,'Tem aparecido feridas dolorosas na região genital',[t4]). /* Cancro mole */
perguntas(q13,'Voce apresenta inchaço ou dor na região da virilha',[t4]). /* Cancro mole */
perguntas(q14,'Tem aparecido feridas indolores',[t5]). /* Sifilis */
perguntas(q15,'Tem tido dores musculares',[t5,t6]). /* Sifilis, Herpes */
perguntas(q16,'Úlceras na região dos genitais que podem sangrar e causar dor ao urinar',[t6]).  /* Herpes */

increment([]).
increment([H|T]):- probabilidade(H,Y), Y1 is Y+1, retract(probabilidade(H,_)), asserta(probabilidade(H,Y1)), Y1 \= 4, increment(T).

init([]).
init([H|T]):- asserta(probabilidade(H,0)), init(T). 

gerarPorcentagens([],0,0).
gerarPorcentagens([H|T],X,Q):- probabilidade(H,Y), P is Y/4, P > 0, asserta(porcentagem(H,P)), gerarPorcentagens(T,X1,Q1), X is X1+P, Q is Q1+1.
gerarPorcentagens([_|T],X,Q):- gerarPorcentagens(T,X,Q).
