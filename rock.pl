% Base conocimiento

anioActual(2015).

%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).

festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).

banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).

%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).

% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).

entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).


% Punto 1

estaDeModa(Banda):-anioActual(Anio),banda(Banda,AnioFundacion,_,Popularidad),
                    Popularidad > 70, (Anio - AnioFundacion) < 5.


% Punto 2

esCareta(Festival):-festival(Festival,_,Bandas,_), member(miranda,Bandas).
esCareta(Festival):-festival(Festival,_,Bandas,_), 
                    estaDeModa(Banda1), estaDeModa(Banda2), Banda1 \= Banda2,
                    member(Banda1,Bandas), member(Banda2,Bandas).


% Punto 3

entradaRazonable(Festival,Entrada):-festival(Festival,lugar(Lugar,_),_,_),
                                    entradasVendidas(Festival,Entrada,_),
                                    esRazonable(Festival,Entrada,Lugar).

esRazonable(Festival,plateaGeneral(Zona),Lugar):-precio(Festival,plateaGeneral(Zona),PrecioTotal),
                                                plusZona(Lugar,Zona,Plus),
                                                Porciento10 is 0.1*PrecioTotal,
                                                Plus < Porciento10.
esRazonable(Festival,campo,_):-precio(Festival,campo,PrecioTotal),
                                popularidad(Popularidad,Festival),
                                PrecioTotal < Popularidad.
esRazonable(Festival,plateaNumerada(Fila),_):-festival(Festival,_,Bandas,_),
                            forall(estaDeModa(Banda),not(member(Banda,Bandas))),
                            precio(Festival,plateaNumerada(Fila),PrecioTotal),
                            PrecioTotal < 750.
                                
popularidad(Popularidad,Festival):-
  festival(Festival,_,Bandas,_),
  findall(Popularidad,(member(Banda,Bandas),banda(Banda,_,_,Popularidad)),Popularidades),
  sumlist(Popularidades,Popularidad).

precio(Festival,campo,PrecioTotal):-festival(Festival,_,_,PrecioTotal).
precio(Festival,plateaGeneral(zona1),PrecioTotal):-festival(Festival,lugar(Lugar,_),_,PrecioBase),
                                            plusZona(Lugar,zona1,Plus),
                                            PrecioTotal is PrecioBase + Plus.
precio(Festival,plateaGeneral(zona2),PrecioTotal):-festival(Festival,lugar(Lugar,_),_,PrecioBase),
                                            plusZona(Lugar,zona2,Plus),
                                            PrecioTotal is PrecioBase + Plus.                                        
precio(Festival,plateaNumerada(Fila),PrecioTotal):-festival(Festival,_,_,PrecioBase),
                                                    PrecioTotal is PrecioBase +200/ Fila.

% Punto 4

nacandpop(Festival):-festival(Festival,_,_,_),
                     forall(festival(Festival,_,Bandas,_),sonBandasNacional(Bandas)).



sonBandasNacional([Banda]):-banda(Banda,_,ar,_).
sonBandasNacional([Banda|Resto]):-banda(Banda,_,ar,_),sonBandasNacional(Resto).


% Punto 5

recaudacion(Festival,Recaudacion):-festival(Festival,_,_,_),
    findall(R,(entradasVendidas(Festival,Entrada,C), precio(Festival,Entrada,PF), R is PF*C),Recaudaciones),
    sumlist(Recaudaciones,Recaudacion).

% Punto 6

estaBienPlaneado(Festival):-festival(Festival,_,Bandas,_),
                            length(Bandas,UbicacionUltima),
                            nth1(UbicacionUltima,Bandas,Banda),
                            esLegendaria(Banda).

esLegendaria(Banda):-banda(Banda,AnioFundacion,Nacionalidad,Popularidad),
                        AnioFundacion < 1980,
                        Nacionalidad \= ar,
                        forall((estaDeModa(BandaModa),banda(BandaModa,_,_,PopularidadBandaModa)),
                         PopularidadBandaModa < Popularidad).


