herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).


% Punto 1

tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(egon,bordedadora).
tiene(peter,trapeador).
tiene(winston,varitaDeNeutrones).


% Punto 2

tieneHerramientaRequerida(Personaje,Herramienta):- tiene(Personaje,Herramienta).
tieneHerramientaRequerida(Personaje,aspiradora(PotenciaRequerida)):- tiene(Personaje,aspiradora(PotenciaPersonaje)),
                                                                        PotenciaPersonaje >= PotenciaRequerida.


% Punto 3

puedeRealizarTarea(Personaje,Tarea):-herramientasRequeridas(Tarea,_),tiene(Personaje,varitaDeNeutrones).
puedeRealizarTarea(Personaje,Tarea):-tiene(Personaje, _), requiereHerramienta(Tarea, _),
	                                    forall(requiereHerramienta(Tarea, Herramienta),
                                             tieneHerramientaRequerida(Personaje, Herramienta)).

requiereHerramienta(Tarea, Herramienta):-
	herramientasRequeridas(Tarea, Herramientas),
	member(Herramienta, Herramientas).


% Punto 4

tareaPedida(dana,ordenarCuarto,20).
tareaPedida(walter,cortarPasto,50).
tareaPedida(walter,limpiarTecho,70).
tareaPedida(louis,limpiarBanio,15).
tareaPedida(jose,cortarPasto,20).

precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).


precioACobrar(Cliente,PrecioTotal):- tareaPedida(Cliente,_,_), 
                                     findall(Precio,precioPorTarea(Cliente,_,Precio),Precios),
                                     sumlist(Precios,PrecioTotal).
                                

precioPorTarea(Cliente,Tarea,Precio):-tareaPedida(Cliete,Tarea,MetroSCuadrado), precio(Tarea,PrecioPorMetros),
                                        Precio is MetroSCuadrado * PrecioPorMetros.
                                        

% Punto 5

aceptanPedido(Personaje,Cliente):-estaDispuesto(Personaje,Cliente), tareaPedida(Cliente,_,_),
                                    forall(tareaPedida(Cliente,Tarea,_),puedeRealizarTarea(Personaje,Tarea)).


estaDispuesto(egon,Cliente):-forall(tareaPedida(Cliente,Tarea,_),not(tareaCompleja(Tarea))).
estaDispuesto(ray,Cliente):-not(tareaPedida(Cliente,limpiarTecho,_)).
estaDispuesto(winston,Cliente):-precioACobrar(Cliente,PrecioTotal), PrecioTotal > 500.
estaDispuesto(peter,_).

tareaCompleja(Tarea):-herramientasRequeridas(Tarea,Herramientas), length(Herramientas,Cantidad), Cantidad > 2.
tareaCompleja(limpiarTecho).