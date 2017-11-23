:- include('dados.pl').
:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).

busca(t1) :- 
	perguntar([q1,q2,q3,q4,q6,q8,q9,q10,q11,q12,q13,q14,q15,q16]),
	gerarPorcentagens([t1,t2,t3,t4,t5,t6],PorcentagemTotal),
	PorcentagemTotal > 0,
	resultado([t1,t2,t3,t4,t5,t6],PorcentagemTotal).

busca(t1) :- 
	sintomas(Id,4),
	doenca(Id,Doenca),
	new(Resultado, dialog('Resultado')),
	new(L1,label(texto,'Pelos sintomas analisados provavelmente você tenha')),
	new(L2,label(texto,Doenca)),
	new(L3,label(texto,'Consulte um médico para melhores informações.')),
	send(Resultado,display,L1,point(20,20)),
	send(Resultado,display,L2,point(330,20)),
	send(Resultado,display,L3,point(20,40)),
	send(Resultado,open_centered),
	limpar.

busca(t1) :- 
	new(Resultado,dialog('Resultado')),
	new(L,label(texto,'Não foi possivel identificar nenhuma doença com as informações fornecidas!')),
	send(Resultado,append(L)),
	send(Resultado,open_centered),
	limpar.

busca(t2) :- 
	perguntar([q2,q3,q4,q5,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16]),
	gerarPorcentagens([t2,t3,t4,t5,t6],PorcentagemTotal),
	PorcentagemTotal > 0,
	resultado([t2,t3,t4,t5,t6],PorcentagemTotal).

busca(t2) :- 
	sintomas(Id,4),
	doenca(Id,Doenca),
	new(Resultado, dialog('Resultado')),
	new(L1,label(texto,'Pelos sintomas analisados provavelmente você tenha')),
	new(L2,label(texto,Doenca)),
	new(L3,label(texto,'Consulte um médico para melhores informações.')),
	send(Resultado,display,L1,point(20,20)),
	send(Resultado,display,L2,point(330,20)),
	send(Resultado,display,L3,point(20,40)),
	send(Resultado,open_centered),
	limpar.

busca(t2) :- 
	new(Resultado,dialog('Resultado')),
	new(L,label(texto,'Não foi possivel identificar nenhuma doença com as informações fornecidas!')),
	send(Resultado,append(L)),
	send(Resultado,open_centered),
	limpar.

resultado(Doencas,PorcentagemTotal) :- 
	new(Resultado,dialog('Resultado')),
	new(L1,label(texto,'As possiveis doenças são:')),
	send(Resultado, append(L1)),
	porcentagemGeral(Doencas,PorcentagemTotal,50,Resultado),
	send(Resultado,open_centered),
	limpar.

porcentagemGeral([],_,_,_).
porcentagemGeral([H|T],PorcentagemTotal,CoordY,Tela):- 
	porcentagem(H,PorcentagemParcial), 
	(PorcentagemParcial == PorcentagemTotal 
		-> Result is PorcentagemParcial*100 
		; Result is ((PorcentagemParcial*100) / PorcentagemTotal)),
	doenca(H,Doenca),
	new(Nome,label(texto,Doenca)),
	new(Porcentagem,label(texto,Result)),
	new(T1,label(texto,' - ')),
	new(T2,label(texto,'%')),
	send(Tela,display,Nome,point(20,CoordY)),
	send(Tela,display,T1,point(220,CoordY)),
	send(Tela,display,Porcentagem,point(280,CoordY)),
	send(Tela,display,T2,point(350,CoordY)),
	CoordNova is CoordY+20, porcentagemGeral(T,PorcentagemTotal,CoordNova,Tela).

porcentagemGeral([_|T],PorcentagemTotal,CoordY,Tela):- porcentagemGeral(T,PorcentagemTotal,CoordY,Tela).
						          


perguntar([]).
perguntar([H|T]) :- 
	perguntas(H,Pergunta,Doencas), 
	new(Questionario,dialog('Diagnostico Medico')),
	new(L1,label(texto,'Responda a seguinte pergunta:')),
	new(L2,label(problema,Pergunta)),
	new(B1,button(sim,and(message(Questionario,return,sim)))),
	new(B2,button(não,and(message(Questionario,return,nao)))),

	send(Questionario,append(L1)),
	send(Questionario,append(L2)),
	send(Questionario,append(B1)),
	send(Questionario,append(B2)),

	send(Questionario,default_button,sim),
	send(Questionario,open_centered),get(Questionario,confirm,Resposta),
	send(Questionario,destroy),
	((Resposta==sim) -> increment(Doencas), perguntar(T);
	perguntar(T)).

verificarSexo :- 
	new(Questionario,dialog('Verificar Sexo')),
	new(Op, menu(sexo, marked)),
	new(B1, button(ok, and(message(Questionario, return, Op?selection)))),

 	send(Questionario, append(Op)),
	send(Op, append(homem)), 
	send(Op, append(mulher)),
	
	send(Questionario, append(B1)),
	send(Questionario, size, size(300,150)),
	send(Questionario, display, Op, point(100, 20)),
	send(Questionario, display, B1, point(100, 100)),  
	send(Questionario,open_centered),
	send(Op, layout, orientation:= vertical),
	send(Questionario, default_button(ok)), get(Questionario,confirm, Resposta),
	send(Questionario, destroy),
	((Resposta == mulher) -> busca(t1);  busca(t2)).


increment([]).							
increment([H|T]):- 
	sintomas(H,Quantidade),
	Y1 is Quantidade+1,
	retract(sintomas(H,_)),
	asserta(sintomas(H,Y1)),
	Y1 \= 4,
	increment(T).

init([]).
init([H|T]):- 
	asserta(sintomas(H,0)),
	init(T).

gerarPorcentagens([],0).
gerarPorcentagens([H|T],PorcentagemTotal):- 
	sintomas(H,Y),
	P is Y/4,
	P > 0,
	asserta(porcentagem(H,P)),
	gerarPorcentagens(T,X1),
	PorcentagemTotal is X1+P.

gerarPorcentagens([_|T],X):-
	gerarPorcentagens(T,X).
	

limpar :- retract(sintomas(_,_)), fail.
limpar :- retract(porcentagem(_,_)), fail.
limpar :- init([t1,t2,t3,t4,t5,t6]), fail.
limpar.

iniciar:-
	new(Menu, dialog('Sistema Especialista')),
	new(L1,label(text,'Sistema Identificador de Doenças Sexualmente Transmissiveis')),
	new(L2,label(text,'Responda a um breve questionário')),
	new(B1,button('Realizar Teste',message(@prolog,verificarSexo))),
	new(B2,button('Fechar',and(message(Menu, destroy),message(Menu,free)))),


	send(Menu,display,L1,point(20,20)),
	send(Menu,display,L2,point(100,100)),
	send(Menu,display,B1,point(80,150)),
	send(Menu,display,B2,point(250,150)),
	send(Menu,open_centered).