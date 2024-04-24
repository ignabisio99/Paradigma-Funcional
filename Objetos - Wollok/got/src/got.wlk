// Personajes

class Personaje{
	
	var property casa
	var property conyuges = []
	var property parejas = []
	var property estaVivo = true
	var property acompanantes = []
	var property personalidad
	
	method patrimonio(){
		return casa.patrimonio() / casa.miembros().size()
	}
	
	method casarseCon(personaje){
		if(casa.puedenCasarse(self,personaje)){
			parejas.add(personaje)
			personaje.parejas().add(self)
		}else{
			self.error("No estan aptos para casamiento")
		}
	}
	
	method estaSolo(){
		return acompanantes.size() == 0
	}
	
	method aliados(){
		const aliados = []
		aliados.add(acompanantes)
		aliados.add(conyuges)
		aliados.add(casa.miembros())
		return aliados
	}
	
	method esPeligroso(){
		return estaVivo && self.criterioPeligrosidad()
		
	}
	
	method criterioPeligrosidad(){
		return conyuges.all({unaConyuge => unaConyuge.casa().esRica()}) || 
			self.aliados().forEach({unAliado => unAliado.patrimonio()}).sum() >=10000 ||
			self.aliados().any({unAliado => unAliado.esPeligroso()})
		}
	
	
}

class Personalidad{
	
	method accion(objetivo){
		
	}
}

object sutiles inherits Personalidad{
	
}

object asesino inherits Personalidad{
	
	override method accion(objetivo){
		objetivo.estaVivo(false)
	}
}

object asesinoPrecavido inherits Personalidad{
	
	override method accion(objetivo){
		if(not(objetivo.estaSolo())){
			objetivo.estaVivo(false)
		}
	}
}

object miedoso inherits Personalidad{
	
	
}




class Casa{
	
	var property patrimonio
	var property ciudad
	var property miembros = []
	
	method miembroAptoCasamiento(persona1,personaje2)
	
	method puedenCasarse(personaje1,personaje2){
		return personaje1.casa().miembroAptoCasamiento() && 
				personaje2.casa().miembroAptoCasamiento()
	}
	
	
	method esRica(){
		return patrimonio > 1000
	}
}


object lannister inherits Casa(patrimonio = 100,ciudad = "Centro"){
	
	override method miembroAptoCasamiento(personaje1,personaje2){
		return personaje1.parejas().size() == 0
	}
}

object stark inherits Casa(patrimonio = 200,ciudad = "Norte"){
	
	override method miembroAptoCasamiento(personaje1,personaje2){
		return personaje1.casa() != personaje2.casa()
	}
}

object guardiaDeLaNoche inherits Casa(patrimonio = 50,ciudad = "El muro"){

	override method miembroAptoCasamiento(personaje1,personaje2){
		return false
	}	
}

// Acompañantes

class Animal{
	
	method esPeligroso(){
		return true
	}
	
	method patrimonio(){
		return 0
	}
}

class Dragon inherits Animal{
	
	
	
}

class Lobo inherits Animal{
	
	var property huargos = true
	
	override method esPeligroso(){
		return huargos
	}
}

// Conspiraciones

class Conspiracion{
	
	var property objetivo
	var property participantes = []
	
	
	method crearConsiparacion(){
		if(not(objetivo.esPeligroso())){
			self.error("No se puede conspirar contra el objetivo")
		}
	}
	
	method cantidadTraidores(){
		
	}	
	
	method objetivoCumplido(){
		return objetivo.esPeligroso()
	}
}
