:- dynamic probabilidade/2.
:- dynamic porcentagem/2.
:- encoding(utf8).

probabilidade(t1,0).
probabilidade(t2,0).
probabilidade(t3,0).
probabilidade(t4,0).
probabilidade(t5,0).
probabilidade(t6,0).


doenca(t1,'Doença Inflamatoria Pélvica (DIP)').
doenca(t2,'Gonorréia').
doenca(t3,'AIDS').
doenca(t4,'Cancro mole').
doenca(t5,'Sífilis').
doenca(t6,'Herpes Genitais').

perguntas(q1,'Você tem tido corrimento vaginal e odor desagradável?',[t1,t2]). /* DIP, Gonorreia - M */
perguntas(q2,'Você tem febre frequentemente?',[t1,t2,t3,t4]). /* DIP, Gonorreia, AIDS, Cancro Mole */
perguntas(q3,'Você sente dores durante a relação sexual?',[t1,t4]). /* DIP, Cancro mole */
perguntas(q4,'Você tem tido dor ou ardência ao urinar?',[t2,t6]). /* Gonorreia, Herpes */
perguntas(q5,'Você tem tido secreção abundante de pus pela uretra?',[t2]). /* Gonorreia - H */
perguntas(q6,'Você tem tido sangramentos fora do periodo menstrual?',[t2]). /* Gonorreia - M */
perguntas(q7,'Tem tido dor ou inchaço em um dos testículos?',[t2]). /* Gonorreia - H */
perguntas(q8,'Você tem tido náusea e vômitos?',[t1]). /* DIP */
perguntas(q9,'Você tem perdido peso rapidamente ou notado uma diminuição no apetite?',[t3,t5]). /* AIDS, Sifilis */
perguntas(q10,'Tem tosse seca prolongada e garganta arranhada?',[t3]). /* AIDS */
perguntas(q11,'Você possui manchas avermelhadas ou pequenas bolinhas vermelhas na pele?',[t3,t5,t6]). /* AIDS, Sifilis, Herpes */
perguntas(q12,'Tem aparecido feridas dolorosas na região genital?',[t4]). /* Cancro mole */
perguntas(q13,'Você apresenta inchaço ou dor na região da virilha?',[t4]). /* Cancro mole */
perguntas(q14,'Tem aparecido feridas indolores?',[t5]). /* Sifilis */
perguntas(q15,'Tem tido dores musculares?',[t5,t6]). /* Sifilis, Herpes */
perguntas(q16,'Úlceras na região dos genitais que podem sangrar e causar dor ao urinar?',[t6]).  /* Herpes */

increment([]).							
increment([H|T]):- probabilidade(H,Quantidade), Y1 is Quantidade+1, retract(probabilidade(H,_)), asserta(probabilidade(H,Y1)), Y1 \= 4, increment(T).

init([]).
init([H|T]):- asserta(probabilidade(H,0)), init(T).

gerarPorcentagens([],0,0).
gerarPorcentagens([H|T],PorcentagemTotal,QtdDoencas):- probabilidade(H,Y), P is Y/4, P > 0, asserta(porcentagem(H,P)), gerarPorcentagens(T,X1,Q1), PorcentagemTotal is X1+P, QtdDoencas is Q1+1.
gerarPorcentagens([_|T],X,Q):- gerarPorcentagens(T,X,Q).
