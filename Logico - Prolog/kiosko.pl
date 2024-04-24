% Base de conocimiento

kioskero(dodian,lunes,9,15).
kioskero(dodian,miercoles,9,15).
kioskero(dodian,viernes,9,15).
kioskero(lucas,martes,10,20).
kioskero(juanC,sabados,18,22).
kioskero(juanC,domingos,18,22).
kioskero(juanF,jueven,10,20).
kioskero(juanF,viernes,12,20).
kioskero(leoC,lunes,14,18).
kioskero(leoC,miercoles,14,18).
kioskero(martu,miercoles,23,24).


% Punto 1

kioskero(vale,Dia,HoraEntrada,HoraSalida):-kioskero(dodian,Dia,HoraEntrada,HoraSalida).
kioskero(vale,Dia,HoraEntrada,HoraSalida):-kioskero(juanC,Dia,HoraEntrada,HoraSalida).


% Punto 2

atiende(Persona,Dia,Hora):-kioskero(Persona,Dia,HoraEntrada,HoraSalida),
                            between(HoraEntrada,HoraSalida,Hora).


% Punto 3

atiendeSola(Persona,Dia,Hora):- atiende(Persona,Dia,Hora),
                                not((atiende(OtraPersona,Dia,Hora), Persona \= OtraPersona)).


% Punto 4

quienesEstan(Dia,PersonasCombinadas):- findall(Persona,kioskero(Persona,Dia,_,_),Personas),
                                        combinaciones(Personas,PersonasCombinadas).

combinaciones([],[]).
combinaciones([Persona | Personas],[Persona | PersonasCombinadas]):-combinaciones(Personas, PersonasCombinadas).
combinaciones([_ | Personas],PersonasCombinadas):-combinaciones(Personas, PersonasCombinadas).
                                        

% Punto 5

vendio(dodian,dia(10,8),[golosinas(1200),cigarros(jockey),golosinas(50)]).
vendio(dodain,dia(12, 8), [bebidas(true, 8), bebidas(false, 1), golosinas(10)]).
vendio(martu,dia(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
vendio(lucas,dia(11, 8), [golosinas(600)]).
vendio(lucas,dia(18, 8), [bebidas(false, 2), cigarrillos([derby])]).


vendedorSuertudo(Persona):-kioskero(Persona,_,_,_),
                            forall(vendio(Persona,_,[Venta|_]), esVentaImportante(Venta)).

esVentaImportante(golosinas(Precio)):- Precio > 100.
esVentaImportante(cigarros(Marcas)):- length(Marcas,Cantidad), Cantidad > 2.
esVentaImportante(bebidas(true,_)).
esVentaImportante(bebidas(false,Cantidad)):- Cantidad > 5.


