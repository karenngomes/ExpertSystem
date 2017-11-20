:- include('dados.pl').
:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).

busca(t1) :- perguntar([q1,q6,q2,q3,q4,q8,q9,q10,q11,q12,q13,q14,q15,q16]), fail.

busca(t1) :- gerarPorcentagens([t1,t2,t3,t4,t5,t6],PorcentagemTotal,Quantidade),
			 Quantidade > 0, resultado([t1,t2,t3,t4,t5,t6],PorcentagemTotal).

busca(t1) :- new(Resultado,dialog('Resultado')),
			 new(L,label(texto,'Não foi possivel identificar nenhuma doença com as informações fornecidas!')),
			 send(Resultado,append(L)),
			 send(Resultado,open_centered), limpar.

busca(t2) :- perguntar([q5,q7,q2,q3,q4,q8,q9,q10,q11,q12,q13,q14,q15,q16]), fail.
busca(t2) :- gerarPorcentagens([t2,t3,t4,t5,t6],PorcentagemTotal,Quantidade), 
			 Quantidade > 0, resultado([t2,t3,t4,t5,t6],PorcentagemTotal).

busca(t2) :- new(Resultado,dialog('Resultado')),
			 new(L,label(texto,'Não foi possivel identificar nenhuma doença com as informações fornecidas!')),
			 send(Resultado,append(L)),
			 send(Resultado,open_centered), limpar.

resultado(Doencas,PorcentagemTotal) :- new(Resultado,dialog('Resultado')),
	new(L1,label(texto,'As possiveis doenças são:')),
	send(Resultado, append(L1)),
	porcentagemGeral(Doencas,PorcentagemTotal,50,Resultado),
	send(Resultado,open_centered),
	limpar.

porcentagemGeral([],_,_,_).
porcentagemGeral([H|T],PorcentagemTotal,CoordY,Tela):- porcentagem(H,PorcentagemParcial), 
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
perguntar([H|T]) :- perguntas(H,Pergunta,Doencas), new(Questionario,dialog('Diagnostico Medico')),
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

verificarSexo :- new(Questionario,dialog('Diagnostico Medico')),
     new(L,label(texto,'Responda a seguinte pergunta:')),
     new(Pergunta,label(prob,'Você é mulher?')),
     new(B1,button(sim,and(message(Questionario,return,sim)))),
     new(B2,button(não,and(message(Questionario,return,nao)))),

     send(Questionario,append(L)),
	 send(Questionario,append(Pergunta)),
	 send(Questionario,append(B1)),
	 send(Questionario,append(B2)),

	 send(Questionario,default_button,sim),
	 send(Questionario,open_centered),get(Questionario,confirm,Resposta),
	 send(Questionario,destroy),
	 ((Resposta==sim)-> busca(t1); busca(t2)).

limpar :- retract(probabilidade(_,_)), fail.
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