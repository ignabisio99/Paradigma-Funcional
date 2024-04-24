% Base de conocimiento

% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido

duenio(andy, woody, 8).
duenio(andy, buzz, 10).
duenio(andy, jessie, 2).
duenio(sam, jessie, 3).
duenio(sam, soldados, 1).

% Relaciona al juguete con su nombre
% Los juguetes son de la forma: deTrapo(tematica), deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras), caraDePapa(partes)

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([ original(pieIzquierdo),original(pieDerecho),repuesto(nariz) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).

% Dice si una persona es coleccionista
esColeccionista(sam).


% Punto 1

tematica(NombreJuguete,Tematica):-juguete(NombreJuguete,deTrapo(Tematica)).
tematica(NombreJuguete,Tematica):-juguete(NombreJuguete,deAccion(Tematica,_)).
tematica(NombreJuguete,Tematica):-juguete(NombreJuguete,miniFiguras(Tematica,_)).
tematica(seniorCaraDePapa,caraDePapa).

esDePlastico(NombreJuguete):-juguete(NombreJuguete,miniFiguras(_,_)).
esDePlastico(NombreJuguete):-juguete(NombreJuguete,caraDePapa(_)).

esDeColeccion(NombreJuguete):-juguete(NombreJuguete,deTrapo(_)).
esDeColeccion(NombreJuguete):-juguete(NombreJuguete,deAccion(Tematica)),esRaro(Tematica).
esDeColeccion(NombreJuguete):-juguete(NombreJuguete,caraDePapa(Tematica)),esRaro(Tematica).


% Punto 2

amigoFiel(Duenio,NombreJuguete):-duenio(Duenio,NombreJuguete,Anios),
                                 forall((duenio(Duenio,OtroJuguete,OtrosAnios),
                                        OtroJuguete \= NombreJuguete),
                                        Anios >= OtrosAnios).


% Punto 3

superValioso(NombreJuguete):-juguete(NombreJuguete,Tipo),
                            esOriginal(Tipo),
                            forall(juguete(NombreJuguete,_),
                                (duenio(Duenio,NombreJuguete,_),not(esColeccionista(Duenio)))).


esOriginal(deAccion(espacial, Partes)):-todasOriginales(Partes).
esOriginal(caraDePapa(Partes)):-todasOriginales(Partes).


todasOriginales([original(_) | Resto]):-
	todasOriginales(Resto).

todasOriginales([original(_)]).


% Punto 4

duoDinamico(Duenio,NombreJuguete1,NombreJuguete2):-hacenBuenaPareja(NombreJuguete1,NombreJuguete2).

hacenBuenaPareja(woody,buzz).
hacenBuenaPareja(buzz,woody).
hacenBuenaPareja(NombreJuguete1,NombreJuguete2):-tematica(NombreJuguete1,Tematica),tematica(NombreJuguete2,Tematica),
                                                NombreJuguete1 \= NombreJuguete2.


% Punto 5

felicidad(Duenio,TotalFelicidad):-duenio(Duenio,_,_),
                                findall(CantidadFelicidad,
                                    (duenio(Duenio,Juguete,_),felicidadQueDa(Duenio,Juguete,CantidadFel)),Felicidades),
                                sumlist(Felicades, TotalFelicidad).

felicidadQueDa(Duenio,NombreJuguete,Cantidad):-juguete(NombreJuguete,Tipo),
                                                cantidadFelicidadDe(Duenio,Tipo,NombreJuguete,Felicidad).

cantidadFelicidadDe(_,deTrapo(_),_,100).
cantidadFelicidadDe(_,miniFiguras(_,CantidadMuniecos),_,Felicidad):- Felicidad is CantidadMuniecos * 20.
cantidadFelicidadDe(Duenio,deAccion(_,_),NombreJuguete,120):-esColeccionista(Duenio),esDeColeccion(NombreJuguete).
cantidadFelicidadDe(Duenio,deAccion(_,_),NombreJuguete,100):-not(esColeccionista(Duenio)).
cantidadFelicidadDe(_,caraDePapa(Partes),_,Felicidad):-	darValorDeFelicidadDePartes(Partes, Valores), 
                                                        sumlist(Valores, Cantidad).

darValorDeFelicidadDePartes([original(_) | Resto], [5 | Otro]):- darValorDeFelicidadDePartes(Resto, Otro).
darValorDeFelicidadDePartes([repuesto(_) | Resto], [8 | Otro]):- darValorDeFelicidadDePartes(Resto, Otro).
darValorDeFelicidadDePartes([original(_)], [5]).
darValorDeFelicidadDePartes([repuesto(_)], [8]).


% Punto 6

puedeJugarCon(Alguien,NombreJuguete):-duenio(Alguien,NombreJuguete,_).
puedeJugarCon(Alguien,NombreJuguete):-puedePrestar(OtraPersona,Alguien), duenio(OtraPersona,NombreJuguete,_),
                                        OtraPersona \= Alguien.


puedePrestar(Persona1,Persona2):-cantidadDeJugetes(Persona1,Cantidad1),cantidadDeJugetes(Persona2,Cantidad2),
                               Persona1 \= Persona2, Cantidad1 > Cantidad2.


cantidadDeJugetes(Persona,Cantidad):- duenio(Persona,_,_),
                                    findall(Juguete,duenio(Persona,Juguete,_),Juguetes),
                                    length(Juguetes,Cantidad).


% Punto 7


%podriaDonar(Duenio,Juguetes,CantidadFelicidad)