// Los Vikingos

class Vikingo{
	
	var property castaSocial
	
	var property cantidadArmas
	
	method puedeIrExpedicion(){
		
		return self.esProductivo() && castaSocial.estaApto(self)
	}
	
	method esProductivo()
	
	method cambiarCasta(castaNueva){
		castaSocial = castaNueva
	}
	
	method ascender(){
		castaSocial.ascender(self)	

		
	}
	
	
	
}


class Soldado inherits Vikingo{
	
	var property asesinatos 
	
	override method esProductivo(){
		return asesinatos > 20
	}
	
	method aumentarRiquezas(){
		cantidadArmas += 10
	}
}

class Granjero inherits Vikingo{
	
	var property cantidadHijos
	var property cantidadHectareas 
	
	override method esProductivo(){
		return 2*cantidadHectareas >= cantidadHijos
	}
	
	method aumentarRiquezas(){
		cantidadHijos =+ 2
		cantidadHectareas =+2
	}
	
}

class CastaSocial{
	
	method estaApto(vikingo){
		return true
	}
	
	method ascender(vikingo){
		
	}
}

object jarl inherits CastaSocial{
	
	override method estaApto(vikingo){
		return vikingo.cantidadArmas() == 0	
	}
	
	override method ascender(vikingo){
		vikingo.aumentarArmas()
		vikingo.cambiarCasta(karl)
	}
	
	
}

object karl inherits CastaSocial{
	
	override method ascender(vikingo){
		vikingo.aumentarRiquezas()
		vikingo.cambiarCasta(thrall)
	}
	
}

object thrall inherits CastaSocial{
	
	
}

class Expedicion{
	
	var property lugaresAInvadir = []	
	var property vikingos = []
	
	method valeLaPena(){
		return lugaresAInvadir.all({unLugar => unLugar.valeLaPena()})
	}
	
	method subirVikingo(unVikingo){
		if(unVikingo.puedeIrExpedicion()){
			unVikingo.add(vikingos)
		}else{
			self.error("Este vikingo no esta capacitado")
		}
	}
	
	method invadirTodo(){
		lugaresAInvadir.forEach({unLugar => unLugar.serInvadida(vikingos)})
		const botinTotal = lugaresAInvadir.sum({unLugar=> unLugar.botin()})
		
	}
	
}

class Aldea{
	
	var property cantidadCrucifijos
	var property comitiva 
	
	method botin(){
		return cantidadCrucifijos
	}
	
	method valeLaPena(vikingos){
		return self.botin()>15
	}
	
	method serInvadida(vikingos){
		cantidadCrucifijos = 0
	}
	
}

class AldeaAmurallada inherits Aldea{

	override method valeLaPena(vikingos){
		return super(vikingos) && vikingos >= comitiva
	}
}

class Captial{
	
	var property cantidadDefensoresDerrotados
	var property factorRiqueza
	
	method botin(){
		return cantidadDefensoresDerrotados * factorRiqueza
	}
	
	method valeLaPena(cantidadVikingos){
		return self.botin()*3>=cantidadVikingos
	}
	
	method serInvadida(cantidadVikingos){
		cantidadDefensoresDerrotados +=cantidadVikingos
	}
}
	