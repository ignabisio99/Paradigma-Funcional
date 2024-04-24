%canta(nombreCancion, cancion)%
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).


% Punto 1

novedoso(Cantante):-canta(Cantante,_),sabeAlMenos2Canciones(Cantante),tiempoConcierto(Cantante,Tiempo), Tiempo <15.
    
    
sabeAlMenos2Canciones(Cantante):-findall(Cancion,canta(Cantante,cancion(Cancion,_)),Canciones),
                                    length(Canciones,CantidadCanciones), CantidadCanciones >= 2.

tiempoConcierto(Cantante,Tiempo):-findall(Minuto,canta(Cantante,cancion(_,Minuto)),Minutos), sumlist(Minutos,Tiempo).


% Punto 2

cantanteAcelerado(Cantante):-canta(Cantante,_),not((canta(Cantante,cancion(_,Duracion)),Duracion > 4)).


% Base Conocimiento 2: concierto(Nombre,Pais,CantFama,Tipo)


concierto(mikuExpo,estadosUnidos,2000,gigante(2,6)).
concierto(magicalMirai,japon,3000,gigante(3,10)).
concierto(vocalektVision,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100,pequenio(4)).


% Punto 2

puedeParticipar(hatsuneMiku,Concierto):-concierto(Concierto,_,_,_).
puedeParticipar(Cantante,Concierto):-canta(Cantante,_),
                                        concierto(Concierto,_,_,gigante(CantMin,DuracionMin)),
                                        tiempoConcierto(Cantante,Tiempo),
                                        Tiempo > DuracionMin,
                                        cantidadCanciones(Cantante,Cantidad),
                                        Cantidad >=CantMin.
puedeParticipar(Cantante,Concierto):-canta(Cantante,_),
                                        concierto(Concierto,_,_,mediano(DuracionMaxima)),
                                        tiempoConcierto(Cantante,Tiempo),
                                        Tiempo < DuracionMaxima.
puedeParticipar(Cantante,Concierto):-concierto(Concierto,_,_,pequenio(DuracionMin)),
                                        canta(Cantante,cancion(_,Tiempo)),
                                        Tiempo > DuracionMin.


cantidadCanciones(Cantante,Cantidad):-canta(Cantante,_),
                                findall(Cancion,canta(Cantante,cancion(Cancion,_)),Canciones),
                                        length(Canciones,Cantidad).


% Punto 3

cantanteMasFamoso(Cantante):-calcularFamaTotal(Cantante,Total),
                            forall((calcularFamaTotal(OtroCantante,OtroTotal),
                                    OtroCantante \= Cantante), Total > OtroTotal).

calcularFamaTotal(Cantante,Total):-canta(Cantante,_),
        calcularNivelFamaParcial(Cantante,Fama), cantidadCanciones(Cantante,Cantidad),
                                    Total is Fama * Cantidad.

calcularNivelFamaParcial(Cantante,FamaTotal):-canta(Cantante,_),
                    findall(Fama,distinct((puedeParticipar(Cantante,Concierto),concierto(Concierto,_,Fama,_))),Famas),
                    sumlist(Famas,FamaTotal).


% Punto 4

conoce(megurineLuka,hatsuneMiku).
conoce(megurineLuka,gumi).
conoce(gumi,seeU).
conoce(seeU,kaito).


conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoParticipanteEntreConocidos(Cantante,Concierto):- 
    puedeParticipar(Cantante, Concierto),
	not((conocido(Cantante, OtroCantante), 
    puedeParticipar(OtroCantante, Concierto))).

%Conocido directo
conocido(Cantante, OtroCantante) :- conoce(Cantante, OtroCantante).

%Conocido indirecto
conocido(Cantante, OtroCantante) :- conoce(Cantante, UnCantante), conocido(UnCantante, OtroCantante).
