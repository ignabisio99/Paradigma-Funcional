% Base de conocimiento y punto1

ingrediente(cupcake, harina(165, reposteria)).
ingrediente(cupcake, mantequilla(sinSal, 165)).
ingrediente(cupcake, azucar(165)).
ingrediente(cupcake, leche).
ingrediente(cupcake, huevos(3)).

ingrediente(torta,mantequilla(conSal,200)).
ingrediente(torta,harina(100,casa)).
ingrediente(torta,harina(20,levadura)).


participante(juan).
participante(susana).

suministro(juan, harina(200, reposteria)).
suministro(juan, mantequilla(conSal, 200)).
suministro(juan, azucar(1000)).
suministro(juan, leche).
suministro(juan, huevos(12)).
suministro(Participante,manteca):-participante(Participante).

receta(juan,cupcake).
receta(juan,torta).
receta(susana,muffin).

% Punto 2

tieneSuficiente(Participante,harina(Cantidad,_)):-suministro(Participante,harina(CantidadPersona,_)),
                                                    Cantidad =< CantidadPersona.
tieneSuficiente(Participante,mantequilla(_, Cantidad)):-suministro(Participante,harina(CantidadPersona,_)),
                                                        Cantidad =< CantidadPersona.
tieneSuficiente(Participante,azucar(Cantidad)):-suministro(Participante,harina(CantidadPersona,_)),
                                                        Cantidad =< CantidadPersona.
tieneSuficiente(Participante,leche):-suministro(Participante,leche).
tieneSuficiente(Participante,huevos(Cantidad)):-suministro(Participante,harina(CantidadPersona,_)),
                                                        Cantidad =< CantidadPersona.
tieneSuficiente(Participante,manteca):-suministro(Participante,manteca).


% Punto 3

puedeHacer(Participante,Receta):-tieneSuficiente(Participante,manteca),
                                ingrediente(Receta,_),
                                forall(ingrediente(Receta,Ingrediente),tieneSuficiente(Participante,Ingrediente)).
                                

% Punto 4

desafio(Participante,Receta):-participante(Participante),
                              ingrediente(Receta,_),
                            not((receta(Participante,RecetaSimilar),recetaSimilar(RecetaSimilar,Receta))).

recetaSimilar(Receta,RecetaSimilar):-ingrediente(Receta,_),
                    findall(
                        IngredienteSimilar,(ingrediente(Receta,Ingrediente),
                        ingrediente(RecetaSimilar,IngredienteSimilar),
                        ingredienteSimilar(Ingrediente,IngredienteSimilar)),
                        Ingredientes),
                    length(Ingredientes,CantidadIngredientes),
                    CantidadIngredientes >=3.
                        

ingredienteSimilar(Ingrediente1,Ingrediente2):-functor(Ingrediente1,Nombre,_),
                                                functor(Ingrediente2,Nombre,_).
ingredienteSimilar(mantequilla, manteca).
ingredienteSimilar(mantequilla, margarina).
ingredienteSimilar(azucar, miel).


% Punto 6

felicidadQueNosDa(Receta,Persona,TotalFelicidad):-participante(Persona),
          ingrediente(Receta,_),
          findall(Felicidad,(ingrediente(Receta,Ingrediente),felicidadQueDa(Ingrediente,Felicidad)),Felicidades),
          not(receta(Persona,Receta)),
           sumlist(Felicidades,TotalFelicidad).

felicidadQueNosDa(Receta,Persona,TotalFelicidad):-participante(Persona),
          ingrediente(Receta,_),
          findall(Felicidad,(ingrediente(Receta,Ingrediente),felicidadQueDa(Ingrediente,Felicidad)),Felicidades),
           sumlist(Felicidades,PreTotalFelicidad),
           receta(Persona,Receta),
           TotalFelicidad is PreTotalFelicidad + 100.
                              
                               
felicidadQueDa(harina(Cantidad,_),Cantidad).  
felicidadQueDa(mantequilla(_, Cantidad),Cantidad).
felicidadQueDa(azucar(Cantidad),Cantidad).
felicidadQueDa(leche,0).
felicidadQueDa(huevos(Cantidad),Cantidad).
felicidadQueDa(manteca,0).


% Punto 7 

esParecida(Receta):-recetaSimilar(Receta,_).

esParecida(Receta):-recetaSimilar(Receta,Receta2),
                              Receta \= Receta2,
                              esParecida(Receta2),
                              Vueltas is Vueltas +1,
                              Vueltas <7.

