% Mi cursada Universitaria

% Punto 1 - Las materias

materia(sistemasYOrganizaciones,3).
materia(analisisDeSistemas,6).
materia(disenioDeSistemas,6).
materia(administracionDeRecursos,6).
materia(proyectoFinal,6).
materia(sistemasOperativos,4).
materia(inglesI,2).
materia(fisicaI,5).
materia(fisicaII,5).
materia(administracionGeneral,3).
materia(mateSuperior,6).
materia(analisisMatematico2,6).



integradora(sistemasYOrganizaciones).
integradora(analisisDeSistemas).
integradora(disenioDeSistemas).
integradora(administracionDeRecursos).
integradora(proyectoFinal).


materiaPesada(Materia):-integradora(Materia), materia(Materia,Hora), Hora = 6.
materiaPesada(Materia):-materia(Materia,Hora), Hora >= 4.   


inicial(analisisMatematico1).
inicial(algebraYGeometriaAnalitica).
inicial(matematicaDiscreta).
inicial(sistemasYOrganizaciones).
inicial(algoritmosYEstructurasDeDatos).
inicial(arquitecturaDeComputadoras).
inicial(ingenieriaYSociedad).
inicial(quimica).
inicial(fisicaI).
inicial(inglesI).
inicial(sistemasDeRepresentacion).

esCorrelativa(fisicaII,fisicaI).
esCorrelativa(fisicaII,analisisI).

% Materias necesarias para administracion General

esCorrelativa(administracionGeneral,administracionDeRecursos).
esCorrelativa(administracionDeRecursos,disenioDeSistemas).
esCorrelativa(disenioDeSistemas,analisisDeSistemas).
esCorrelativa(analisisDeSistemas,sistemasYOrganizaciones).

materiasNecesarias(Materia,Correlativa):- esCorrelativa(Materia,Correlativa).
materiasNecesarias(Materia,Correlativa):- esCorrelativa(OtraCorrelativa,Correlativa),
                                            materiasNecesarias(Materia,OtraCorrelativa).

materiasQueHabilita(Materia,Habilita):-materiasNecesarias(Habilita,Materia).



% Materias necesarias para Teoria de control

esCorrelativa(teoriaDeControl,quimica).
esCorrelativa(teoriaDeControl,mateSuperior).
esCorrelativa(mateSuperior,analisisMatematico2).
esCorrelativa(analisisMatematico2,analisisMatematico1).
esCorrelativa(analisisMatematico2,algebraYGeometriaAnalitica).
esCorrelativa(redesDeInformacion,comunicaciones).
esCorrelativa(proyectoFinal,redesDeInformacion).



% Los estudiantes

estudiante(vero).
curso(vero,Materias,8,anual(2016)):-inicial(Materias).
rindio(vero,inglesII,10).

estudiante(alan).
curso(alan,sistemasYOrganizaciones,6,anual(2017)).
curso(alan,analisisMatematico1,6,anual(2017)).
curso(alan,analisisDeSistemas,2,anual(2018)).
curso(alan,analisisDeSistemas,9,anual(2019)).
curso(alan,fisicaI,2,anual(2019)).
rindio(alan,sistemasYOrganizaciones,4).
rindio(alan,inglesI,2).


materiaCursada(Materia,Estudiante):-curso(Estudiante,Materia,Nota,_), Nota >=6.
materiaCursada(Materia,Estudiante):-rindio(Estudiante,Materia,Nota), Nota >=6.

materiaAprobada(Materia,Estudiante):-curso(Estudiante,Materia,Nota,_), Nota >=8.
materiaAprobada(Materia,Estudiante):-rindio(Estudiante,Materia,Nota), Nota >=6.


% Modalidades

curso(jhonny,sistemasYOrganizaciones,7,anual(2015)).
curso(jhonny,quimica,2,cuatrimestral(2015,1)).
curso(jhonny,quimica,8,cuatrimestral(2015,2)).
curso(jhonny,fisicaI,6,cursoVerano(2016)).


recursoMateria(Persona,Materia):-curso(Persona,Materia,_,Anio1),curso(Persona,Materia,_,Anio2), Anio1 \= Anio2.

anioCursada(Alumno,Materia,Anio,Forma):-curso(Alumno,Materia,_,Modalidad), anioSegunCiclo(Modalidad,Anio,Forma).

anioSegunCiclo(cuatrimestral(Anio,1),Anio, primerCuatrimestre).
anioSegunCiclo(cuatrimestral(Anio,2),Anio, segundoCuatrimestre).
anioSegunCiclo(anual(Anio),Anio, anual).
anioSegunCiclo(cursoVerano(Anio),AnioAcademico, verano):- AnioAcademico is Anio -1.


% Perfiles de Estudiantes

sinDescanso(Alumno):-recursoMateria(Alumno,_),
                        forall(recursoMateria(Alumno,Materia),casoSinDescanso(Alumno,Materia)).

casoSinDescanso(Alumno,Materia):-curso(Alumno,Materia,_,cuatrimestral(Anio,1)),
                                    curso(Alumno,Materia,_,cuatrimestral(Anio,2)).
casoSinDescanso(Alumno,Materia):-curso(Alumno,Materia,_,cuatrimestral(Anio,2)),
                        curso(Alumno,Materia,_,anual(Anio2)), Anio2 is Anio + 1.

casoSinDescanso(Alumno,Materia):-curso(Alumno,Materia,_,anual(Anio)),
                                    curso(Alumno,Materia,_,anual(Anio2)), Anio2 is Anio + 1.
casoSinDescanso(Alumno,Materia):-curso(Alumno,Materia,_,anual(Anio)),
                                    curso(Alumno,Materia,_,cuatrimestral(AnioSiguiente,1)),AnioSiguiente is Anio + 1.

casoSinDescanso(Alumno,Materia):-curso(Alumno,Materia,_,cursoVerano(Anio)), curso(Alumno,Materia,_,anual(Anio)).
casoSinDescanso(Alumno,Materia):-curso(Alumno,Materia,_,cursoVerano(Anio)), 
                        curso(Alumno,Materia,_,cuatrimestral(Anio,1)).


invictus(Alumno):- not(recursoMateria(Alumno,_)).

repechaje(Alumno):-
    curso(Alumno,Materia,Nota,anual(Anio)),Nota < 6,
        curso(Alumno,Materia,Nota2,cuatrimestral(AnioSiguiente,1)),AnioSiguiente is Anio + 1,Nota2 >7.

buenaCursada(Alumno):- forall(curso(Alumno,_,Nota,_), Nota >= 8).

seLoQueHicisteElVeranoPasado(Alumno):-forall(anioCursada(Alumno,_,Anio,_),
                                         anioCursada(Alumno,_,Anio,verano)).

%mayorAnio(Alumno,Anio):-anioCursada(Alumno,_,Anio,_),forall((anioCursada(Alumno,_,Anio2,_),Anio \=Anio2), Anio > Anio2).
%menorAnio(Alumno,Anio):-anioCursada(Alumno,_,Anio,_),forall((anioCursada(Alumno,_,Anio2,_),Anio \=Anio2), Anio < Anio2).


perfilUnico(Alumno):-sinDescanso(Alumno),not(invictus(Alumno)),not(repechaje(Alumno)),not(buenaCursada(Alumno)).
perfilUnico(Alumno):-invictus(Alumno),not(sinDescanso(Alumno)),not(repechaje(Alumno)),not(buenaCursada(Alumno)).
perfilUnico(Alumno):-repechaje(Alumno),not(invictus(Alumno)),not(sinDescanso(Alumno)),not(buenaCursada(Alumno)).
perfilUnico(Alumno):-buenaCursada(Alumno),not(invictus(Alumno)),not(repechaje(Alumno)),not(sinDescanso(Alumno)).


curso(jean,quimica,2,anual(2016)).
curso(jean,quimica,3,cuatrimestral(2017,1)).
curso(jean,quimica,4,cuatrimestral(2017,2)).
curso(jean,quimica,5,anual(2018)).
curso(jean,fisicaI,2,cursoVerano(2018)).
curso(jean,fisicaI,2,anual(2018)).

curso(luis,quimica,2,anual(2016)).
curso(luis,quimica,3,cuatrimestral(2017,2)).
curso(luis,fisicaI,2,anual(2017)).
curso(luis,fisicaI,10,cuatrimestral(2018,1)).

curso(alejo,quimica,6,anual(2016)).
curso(alejo,fisicaI,6,cursoVerano(2017)).
curso(alejo,matematicaDiscreta,2,anual(2017)).
curso(alejo,matematicaDiscreta,8,cursoVerano(2018)).


curso(leandro,quimica,10,cuatrimestral(2016,1)).
curso(leandro,fisicaI,10,cuatrimestral(2016,2)).







% Desempeño Academico


materiasAnuales(Alumno,Total):-findall(Nota,curso(Alumno,_,Nota,anual(_)),Lista), sumlist(Lista,Total).


notaCuatrimestral(_,Nota,Numero,Total):- Total is Nota - Numero.
materiasCuatrimestrales(Alumno,Total2):-findall(Total,(curso(Alumno,_,Nota,cuatrimestral(_,Numero)),
                                           notaCuatrimestral(Alumno,Nota,Numero,Total)),Lista),sumlist(Lista,Total2).


notaVerano(_,Nota,Anio,Total):- esAnioPar(Anio), Total is 5.
notaVerano(_,Nota,Anio,Total):- not(esAnioPar(Anio)), Total is Nota / 2.
esAnioPar(Anio):- 0 is Anio mod 2.
materiasVerano(Alumno,Total2):-findall(Total,(curso(Alumno,_,Nota,cursoVerano(Anio)),
                                                notaVerano(Alumno,Nota,Anio,Total)),Lista),sumlist(Lista,Total2).

cantidadMaterias(Alumno,Total2):-findall(Materia,curso(Alumno,Materia,_,_),Lista), length(Lista,Total2).

desempenioAcademico(Alumno,Total):- materiasAnuales(Alumno,Total2), materiasCuatrimestrales(Alumno,Total3),
                                      materiasVerano(Alumno,Total4),cantidadMaterias(Alumno,Total5),
                                        Total is ((Total2+Total3+Total4)/Total5).
                                            






