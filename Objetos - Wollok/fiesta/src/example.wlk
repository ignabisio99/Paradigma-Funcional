class Intercambiador{
	const persona1
	const persona2
	const fiesta
	
	method intercambiarDisfraz(){
		if (self.ambosEnLaFiesta() && self.algunoDesconforme()){
		self.intercambio()
		}
	}
	
	method ambosEnLaFiesta(){
		return fiesta.invitados().contains(persona1) &&
				fiesta.invitados().contains(persona2)
	}
	
	method algunoDesconforme(){
		return not(persona1.conformeConTraje(fiesta)) || not(persona2.conformeConTraje(fiesta))
	}
	
	method intercambio(){
		const disfrazAnterior = persona1.disfraz()
		persona1.disfraz(persona2.disfraz())
		persona2.disfraz(disfrazAnterior)
	}
}

class Punteador{
	var persona
	var fiesta
	
	method calcularPuntaje(){
		return persona.puntajeDisfraz(persona,fiesta)
	}
	method estaSatisfecho(){
		return persona.conformeConTraje(fiesta)
	}
}

class Fiesta{
	
	var property lugar
	var property fecha = new Date()
	var property invitados = []
	
	method esUnBodrio(){
		return invitados.all({unInvitado =>not(unInvitado.confomeConTraje(self))})
	}
	
	method mejorDisfraz(){
		const invitadoGanador = invitados.max({unInvitado => unInvitado.puntajeDisfraz(self)})
		return invitadoGanador.disfraz()
	}
	
	method agregarAsistente(persona){
		if(not(invitados.contains(persona))){
			invitados.add(persona)
		}else{
			self.error("Ya estas en la lista")
		}
	}
}

class Persona{
	
	var property disfraz
	var property edad
	var property fiestaAsistida
	var property personalidad
	const property personalidad2
	
	method puntajeDisfraz(fiesta){
		return disfraz.puntaje(self,fiesta)
	}
	
	method esSexy(){
		return personalidad.esSexy(self)
	}
	
	method confomeConTraje(fiesta){
		return self.puntajeDisfraz(fiesta) > 10 && personalidad2.conforme(fiesta)
	}
	

	
}


object alegre{
	method esSexy(persona){
		return false
	}
}

object taciturnas{
	method esSexy(persona){
		return persona.edad() < 30
	}
}

object cambiante{
	method esSexy(persona){
		
	}
}

class PersonaCaprichosa inherits Persona{
	
	 method confome(fiesta){
		return self.disfraz().nombre().size().even()
	}
}

class PersonaPretenciosa inherits Persona{
	
	method conforme(fiesta){
		 
	}
}

class PersonaNumerologa inherits Persona{
	
	var cifraElegida
	
	method conforme(fiesta){
		return self.puntajeDisfraz(fiesta) == cifraElegida
	}
}


class Disfraz{
	
	var property nombre
	var property tipoDisfraz = []
	var property fechaConfeccion = new Date()
	var property nivelGracia
	var property careta
	method puntaje(persona,fiesta){
		return tipoDisfraz.sum({unTipo => unTipo.puntaje(self,persona,fiesta,careta)})
	}
}

object gracioso{
	
	method puntaje(disfraz,persona,fiesta,careta){
		if(persona.edad()>50){
		return disfraz.nivelGracia() * 3}
		else{
		return disfraz.nivelGracia()
		}
	}
	
}

object tobaras{
	
	method puntaje(disfraz,persona,fiesta,careta){
		if(fiesta.fecha() - disfraz.fechaConfeccion() >= 2 ){
			return 5
		}else{
			return 3
		}
	}
}

object caretas{
	
	method puntaje(disfraz,persona,fiesta,careta){
		return careta.puntaje()
	}
}

object sexies{
	
	method puntaje(disfraz,persona,fiesta){
		if(persona.esSexy()){
			return 15
		}else{
			return 2
		}
	}
}

object mickeyMouse{
	var property puntaje = 8
}

object osoCarolina{
	var property puntaje = 5
}