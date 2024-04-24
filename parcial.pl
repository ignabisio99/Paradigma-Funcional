% Base de conocimiento 

% alumno(Nombre,Edad,IdiomaNativo,PlanContratado,Idiomas).
% donde Idiomas es una lista del functor curso(Idioma,Nivel)
% hay mas alumnos modelados por el tema de los seguidores


% Punto 1

idioma(ingles).
idioma(espaniol).
idioma(portugues).
idioma(italiano).
idioma(hebreo).
idioma(frances).
idioma(chino).
idioma(latin).
idioma(klingon).
idioma(esperanto).



idiomaGratuito(ingles).
idiomaGratuito(espaniol).
idiomaGratuito(portugues).
idiomaPremium(italiano).
idiomaPremium(hebreo).
idiomaPremium(frances).
idiomaPremium(chino).


alumno(cristian,22,espaniol,gratuito,[curso(ingles,7),curso(portugues,15)]).
alumno(maria,34,ingles,premium(bronce),[curso(hebreo,1)]).
alumno(felipe,60,italiano,premium(oro),[]).
alumno(juan,12,espaniol,aCuentaGotas,[curso(ingles,20)]).

alumno(raul,24,espaniol,gratuito,[curso(ingles,18),curso(portugues,20),curso(latin,19)]).
alumno(alejo,18,espanio,premium(oro),[curso(portugues,18),curso(italiano,19),curso(hebreo,20),
                                curso(chino,20),curso(frances,20),curso(latin,20)]).

% Punto 2

nivelAvanzado(Alumno,Idioma):-alumno(Alumno,_,_,_,Idiomas),
                             member(curso(Idioma,Nivel),Idiomas),
                             Nivel >= 15.

% Punto 3

certificadoOtorgado(Alumno,Idioma):-terminoCurso(Alumno,Idioma).

terminoCurso(Alumno,Idioma):-alumno(Alumno,_,_,_,Idiomas),
                        member(curso(Idioma,20),Idiomas).


% Punto 4

lenguaCodiciada(Idioma1,Idioma2):-alumno(_,_,Idioma1,_,_),
                                    idioma(Idioma2),
                                    forall(alumno(Alumno,_,Idioma1,_,_),
                                    idiomaQueEstaCursando(Alumno,Idioma2)).

idiomaQueEstaCursando(Alumno,Idioma):-alumno(Alumno,_,_,_,Idiomas),
                            member(curso(Idioma,_),Idiomas).


% Punto 5

idiomaQueFaltaAprender(Alumno,Idioma):- alumno(Alumno,_,_,_,_),
                                        idioma(Idioma),
                                        not(puedeHablarIdioma(Alumno,Idioma)).

puedeHablarIdioma(Alumno,Idioma):-nivelAvanzado(Alumno,Idioma).
puedeHablarIdioma(Alumno,Idioma):-idiomaNativo(Alumno,Idioma).

idiomaNativo(Alumno,Idioma):- alumno(Alumno,_,Idioma,_,_).


% Punto 6

poliglota(Alumno):-hablaAlMenos(Alumno,3).
                    
hablaAlMenos(Alumno,CantidadIdiomas):-alumno(Alumno,_,_,_,_),
                findall(Idioma,puedeHablarIdioma(Alumno,Idioma),Idiomas),
                    length(Idiomas,CantidadIdiomasQueHabla),
                    CantidadIdiomasQueHabla >= CantidadIdiomas.


% Punto 7

puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,gratuito,_),
                                idiomaGratuito(Idioma).

puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,premium(bronce),_),
                                idiomaGratuito(Idioma).      
puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,premium(bronce),IdiomasEnCurso),
                                length(IdiomasEnCurso,CantidadIdiomasEnCurso),
                                CantidadIdiomasEnCurso =< 3,
                                idiomaPremium(Idioma).

puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,premium(plata),_),
                                idiomaGratuito(Idioma).
puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,premium(plata),IdiomasEnCurso),
                                length(IdiomasEnCurso,CantidadIdiomasEnCurso),
                                CantidadIdiomasEnCurso =< 7,
                                idiomaPremium(Idioma).                            

puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,premium(oro),_),
                                idiomaGratuito(Idioma).
puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,premium(oro),_),
                                idiomaPremium(Idioma).

puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,aCuentaGotas,_),
                                idiomaGratuito(Idioma).          
puedeHacerCurso(Alumno,Idioma):-alumno(Alumno,_,_,aCuentaGotas,_),
                                idiomaPremium(Idioma).                                

% Punto 8 - Modelo la base de conocimiento de Una persona sigue A
% Ej: cristian sigue a maria,felipe y alejo

sigueA(cristian,maria).
sigueA(cristian,felipe).
sigueA(cristian,alejo).
sigueA(maria,raul).
sigueA(juan,maria).
sigueA(raul,juan).
sigueA(alejo,cristian).


tieneExcentricismo(Alumno):- alumno(Alumno,_,_,_,_),
                        forall(sigueA(Seguidor,Alumno),esExcentrico(Seguidor)).

esExcentrico(Alumno):-not(puedeHablarIdioma(Alumno,ingles)),
                        hablaAlMenos(Alumno,5).
esExcentrico(Alumno):-puedeHablarIdioma(Alumno,esperanto).
esExcentrico(Alumno):-puedeHablarIdioma(Alumno,klingon).
esExcentrico(Alumno):-puedeHablarIdioma(Alumno,latin).


% Punto 9 

idiomaQuePuedeTraducir(Idioma,Alumno):-puedeHablarIdioma(Alumno,Idioma).
idiomaQuePuedeTraducir(Idioma,Alumno):-conoceAlguien(Alumno,OtraPersona), puedeHablarIdioma(OtraPersona,Idioma).

conoceAlguien(Alumno,OtraPersona):- sigueA(Alumno,OtraPersona).
conoceAlguien(Alumno,OtraPersona):- sigueA(Alumno,OtraPersona2), conoceAlguien(OtraPersona2,OtraPersona).
