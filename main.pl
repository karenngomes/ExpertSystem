:- include('dados.pl').
:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- encoding(utf8).

 /* busca a ser testada*/
busca(t1) :- perguntar([q1,q6,q2,q3,q4,q8,q9,q10,q11,q12,q13,q14,q15,q16]),
	gerarPorcentagens([t1,t2,t3,t4,t5,t6],G,Q), Q > 0, resultado([t1,t2,t3,t4,t5,t6],G).
busca(t1) :- gerarPorcentagens([t1,t2,t3,t4,t5,t6],G,Q), Q > 0, resultado([t1,t2,t3,t4,t5,t6],G).
busca(t1) :- new(Di,dialog('Resultado')),
			 new(L,label(texto,'Não foi possivel identificar nenhuma doença com as informações fornecidas!')),
			 send(Di,append(L)),
			 send(Di,open_centered), limpar.

busca(t2) :- perguntar([q5,q7,q2,q3,q4,q8,q9,q10,q11,q12,q13,q14,q15,q16]),
	gerarPorcentagens([t2,t3,t4,t5,t6],G,Q), Q > 0, resultado([t2,t3,t4,t5,t6],G).
busca(t2) :- gerarPorcentagens([t2,t3,t4,t5,t6],G,Q), Q > 0, resultado([t2,t3,t4,t5,t6],G).
busca(t2) :- new(Di,dialog('Resultado')),
			 new(L,label(texto,'Não foi possivel identificar nenhuma doença com as informações fornecidas!')),
			 send(Di,append(L)),
			 send(Di,open_centered), limpar.

resultado(X,G) :- new(Di,dialog('Resultado')),
				  new(L3,label(texto,'As possiveis doenças são:')),
				  send(Di, append(L3)),
				  porcentagemGeral(X,G,50,Di),
				  send(Di,open_centered),
				  limpar.

porcentagemGeral([],_,_,_).
porcentagemGeral([H|T],G,Y,D):- porcentagem(H,Q), (Q == G -> R is Q*100 ; R is ((Q*100) / G)),
								doenca(H,X),
								new(Doenca,label(texto,X)),
								new(Porcentagem,label(texto,R)),
								new(T1,label(texto,' - ')),
								new(T2,label(texto,'%')),
								send(D,display,Doenca,point(20,Y)),
								send(D,display,T1,point(220,Y)),
								send(D,display,Porcentagem,point(280,Y)),
								send(D,display,T2,point(350,Y)),
								Y1 is Y+20, porcentagemGeral(T,G,Y1,D).
porcentagemGeral([_|T],G,Y,D):- porcentagemGeral(T,G,Y,D).
						          


perguntar([]).
perguntar([H|T]) :- perguntas(H,Q,S), new(Di,dialog('Diagnóstico médico')),
				     new(L2,label(texto,'Responda a seguinte pergunta')),
				     new(La,label(prob,Q)),
				     new(B1,button(sim,and(message(Di,return,sim)))),
				     new(B2,button(não,and(message(Di,return,não)))),

				     send(Di,append(L2)),
					 send(Di,append(La)),
					 send(Di,append(B1)),
					 send(Di,append(B2)),

					 send(Di,default_button,sim),
					 send(Di,open_centered),get(Di,confirm,Answer),
					 send(Di,destroy),
					 ((Answer==sim)-> increment(S), perguntar(T);
					 perguntar(T)).

inicio :- new(Di,dialog('Diagnóstico médico')),
     new(L,label(texto,'Responda a seguinte pergunta:')),
     new(P,label(prob,'Você é mulher?')),
     new(B1,button(sim,and(message(Di,return,sim)))),
     new(B2,button(não,and(message(Di,return,não)))),

     send(Di,append(L)),
	 send(Di,append(P)),
	 send(Di,append(B1)),
	 send(Di,append(B2)),

	 send(Di,default_button,sim),
	 send(Di,open_centered),get(Di,confirm,Resposta),
	 send(Di,destroy),
	 ((Resposta==sim)-> busca(t1); busca(t2)).

limpar :- retract(probabilidade(_,_)), fail.
limpar :- retract(porcentagem(_,_)), fail.
limpar :- init([t1,t2,t3,t4,t5,t6]), fail.
limpar.

iniciar:-
	new(Menu, dialog('Sistema Especialista', size(1000,1000))),
	new(L,label(text,'Sistema Identificador de Doenças Sexualmente Transmissiveis')),
	new(@texto,label(text,'Responda a um breve questionário')),
	new(@sair,button('Fechar',and(message(Menu, destroy),message(Menu,free)))),
	new(@boton,button('Realizar Teste',message(@prolog,inicio))),

	send(Menu,display,L,point(20,20)),
	send(Menu,display,@boton,point(80,150)),
	send(Menu,display,@texto,point(100,100)),
	send(Menu,display,@sair,point(250,150)),
	send(Menu,open_centered).
