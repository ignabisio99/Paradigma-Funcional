% Base conocimiento

jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra,piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon,carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta,panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


% Punto 1: Jugando con los Items

tieneItem(Personaje,Item):-jugador(Personaje,Items,_), member(Item,Items).

sePreocupaPorSuSalud(Personaje):-comestible(Item),comestible(Item2),tieneItem(Personaje,Item),tieneItem(Personaje,Item2),
                                Item \= Item2.

cantidadDelItem(Personaje,Item,Cantidad):-jugador(Personaje,_,_), tieneItem(_,Item),
                                        findall(Item,tieneItem(Personaje,Item),Items), length(Items,Cantidad).

tieneMasDe(Personaje,Item):- cantidadDelItem(Personaje,Item,Cantidad1),
                            forall( (cantidadDelItem(OtroPersonaje,Item,Cantidad2),
                                    OtroPersonaje\=Personaje),
                                    Cantidad1 >= Cantidad2).

% Punto2: Alejarse De La Oscuridad

hayMonstruos(Lugar):-lugar(Lugar,_,NivelOscuridad),NivelOscuridad>6.

correPeligro(Personaje):-lugar(Lugar,Personajes,_),hayMonstruos(Lugar),member(Personaje,Personajes).
correPeligro(Personaje):-estaHambriento(Personaje),not(tieneItemsComestibles(Personaje)).

estaHambriento(Personaje):-jugador(Personaje,_,NivelHambre), NivelHambre < 4.
tieneItemsComestibles(Personaje):-tieneItem(Personaje,Item),comestible(Item).

nivelPeligrosidad(Lugar,Peligrosidad):-lugar(Lugar,Poblacion,_),
                                not(hayMonstruos(Lugar)),
                                lugarHabitado(Poblacion),
                                findall(Personaje,(member(Personaje,Poblacion),estaHambriento(Personaje)),Personajes),
                                length(Personajes,CantidadHambrientos),
                                length(Poblacion,CantidadTotal),
                                Peligrosidad is CantidadHambrientos*100/CantidadTotal.

nivelPeligrosidad(Lugar,Peligrosidad):-hayMonstruos(Lugar),Peligrosidad is 100.
nivelPeligrosidad(Lugar,Peligrosidad):-lugar(Lugar,Poblacion,NivelOscuridad),
                                        not(lugarHabitado(Poblacion)),
                                        Peligrosidad is NivelOscuridad * 10.
                        


lugarHabitado(Poblacion):-length(Poblacion,CantidadDePoblacion), CantidadDePoblacion \= 0.


% Punto 3: A construir

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).


puedeConstruir(Personaje, Objeto):-
	item(Objeto, Elementos),
	dispone(Personaje, Elementos).

dispone(Persona, [itemSimple(Item, Cantidad) | Resto]):-
	cantidadDelItem(Persona, Item, CantidadQuePosee),
	Cantidad =< CantidadQuePosee,
	dispone(Persona, Resto).

dispone(Persona, [itemCompuesto(Item) | Resto]):-
	puedeConstruir(Persona, Item),
	dispone(Persona, Resto).

dispone(Persona, [itemSimple(Item, Cantidad)]):-
	cantidadDelItem(Persona, Item, CantidadQuePosee),
	Cantidad =< CantidadQuePosee.

dispone(Persona, [itemCompuesto(Item)]):-
	puedeConstruir(Persona, Item).


%Punto 4

%A) Si consultamos por el nivel de peligrosidad del desierto, nos va a devolver falso, ya que "desierto" no esta 
%en nuestra base de conocimiento, por lo que si le preguntamos por cualquier lugar que no se encuentre en nuestra base
%lo va a dar como falso por el principio de universo cerrado.

%B) La ventaja que nos da el paradigma Logico frente al Funcional a la hora de realizar consultas es que con un mismo
%predicado, podemos obtener las respuesta de Quienes los cumplen, que nos de todos, o preguntar por alguien en
%especifico, mientras que eso en Funcional deberíamos hacer 1 funcion para cada consulta que queramos.