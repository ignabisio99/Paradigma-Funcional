% Base Conocimiento

mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(ron, pura, [amistad, diversion, coraje]).
mago(hermione, impura, [inteligencia, coraje, responsabilidad, amistad, orgullo]).
mago(hannahAbbott, mestiza, [amistad, diversion]).
mago(draco, pura, [inteligencia, orgullo]).
mago(lunaLovegood, mestiza, [inteligencia, responsabilidad, amistad, coraje]).

odia(harry,slytherin).
odia(draco,hufflepuff).

casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).

caracteriza(gryffindor,amistad).
caracteriza(gryffindor,coraje).
caracteriza(slytherin,orgullo).
caracteriza(slytherin,inteligencia).
caracteriza(ravenclaw,inteligencia).
caracteriza(ravenclaw,responsabilidad).
caracteriza(hufflepuff,amistad).
caracteriza(hufflepuff,diversion).


% Punto 1

permiteEntrar(slytherin,Mago):-mago(Mago, Sangre, _),Sangre \= impura.
permiteEntrar(Casa,Mago):-mago(Mago,_,_),casa(Casa),Casa \= slytherin.


% Punto 2

tieneCaracter(Mago,Casa):-casa(Casa),mago(Mago,_,Caracteristicas),
                            forall(caracteriza(Casa,Caracteristica),member(Caracteristica,Caracteristicas)).


% Punto 3

casaPosible(Mago,CasaPosible):-permiteEntrar(CasaPosible,Mago), 
                                tieneCaracter(Mago,CasaPosible),not(odia(Mago,CasaPosible)).


% Punto 4

cadenaDeAmistades(Magos):-forall(member(Mago,Magos),esAmistoso(Mago)), compartenCasas(Magos).

esAmistoso(Mago):-mago(Mago,_,Caracteristicas), member(amistad,Caracteristicas).

compartenCasas([Mago1, Mago2 | Resto]):-casaPosible(Mago1, Casa), casaPosible(Mago2, Casa),
                                            compartenCasas([Mago2 | Resto]).
compartenCasas([Mago1, Mago2]):-casaPosible(Mago1, Casa),casaPosible(Mago2, Casa).


% Las copas de la casa

lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).
alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).


hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione,responder("donde se encuentra un bezoar", 15, snape)).
hizo(hermione, responder("wingardium leviosa", 25,flitwick)).
hizo(ron, irA(bosque)).
hizo(draco, irA(mazmorras)).

esDe(harry, gryffindor).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(draco, slytherin).
esDe(hannahAbbott, ravenclaw).
esDe(lunaLovegood,hufflepuff).


% Punto 5

esBuenAlumno(Mago):-hizo(Mago,_),forall((hizo(Mago, Accion)), (suma(_,Accion,Puntos), not(Puntos < 0))).

suma(_,fueraDeCama, Puntos):-
	Puntos is -50.
suma(_,irA(Lugar), Puntos):-
	lugarProhibido(Lugar, Puntaje),
	Puntos is -Puntaje.
suma(_ ,buenaAccion(_, Puntos), Puntos).
suma(Mago,responder(_, Valor, Profesor), Puntos):-
	alumnoFavorito(Profesor, Mago),
	Puntos is (Valor*2).
suma(Mago, responder(_, _, Profesor), Puntos):-
	alumnoOdiado(Profesor, Mago),
	Puntos is 0.

% Punto 6

puntosDeCasa(Casa,PuntosTotal):-casa(Casa),
                                    findall(Punto,sumaAlumnoDe(Casa,Suma),Puntos), sumlist(Puntos,PuntosTotal).

sumaAlumnoDe(Casa, Cantidad):-
	esDe(Mago, Casa),
	findall(Puntos, (hizo(Mago, Accion), suma(Mago, Accion, Puntos)), PuntosMago),
	sumlist(PuntosMago, Cantidad).
