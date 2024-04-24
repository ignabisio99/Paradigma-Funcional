class Equipo{
	
	var jugadoresTitulares = []
	var jugadoresSuplentes = []
	var property dt
	
	method tienePotencial(){
		const habilidadesTotalesTitulares = self.habilidadTotalJugadores(jugadoresTitulares)
		const habilidadesTotalesSuplentes = self.habilidadTotalJugadores(jugadoresSuplentes)
		
		return habilidadesTotalesTitulares >= 2* habilidadesTotalesSuplentes ||
				self.promedioEdadPlantel() < 26
			
	}
	
	method agregarJugador(unJugador){
		if(not(unJugador.estaLesionado())){
			self.agregarJugadorNuevo(unJugador)
		}else{
			self.error("No se puede agregar a un jugador lesionado")
		}
	}
	
	method agregarJugadorNuevo(unJugador){
		const peorJugadorTitular = self.peorJugadorTitular()
		if(peorJugadorTitular.habilidadTotal() > unJugador.habilidadTotal()){ 
			jugadoresTitulares.add(unJugador)
			jugadoresTitulares.remove(peorJugadorTitular)
			jugadoresSuplentes.add(peorJugadorTitular)
			}else{
			jugadoresSuplentes.add(unJugador)
			}
	}
	
	method peorJugadorTitular(){
		return jugadoresTitulares.min({unJugador => unJugador.habilidadTotal()})
	}
	
	method todosLosJugadores(){
		const jugadores = []
		jugadores.addAll(jugadoresTitulares)
		jugadores.addAll(jugadoresSuplentes)
		return jugadores
	}
	
	method promedioEdadPlantel(){
		return self.todosLosJugadores().sum({unJugador => unJugador.edad()}) / 
			self.todosLosJugadores().size()
	}
	
	
	method habilidadTotalJugadores(unosJugadores){
		return unosJugadores.sum({unJugador => unJugador.habilidadTotal()})
	}
	
	method estaApto(){
		const jugadoresAptos = self.jugadoresNoLesionados()
		return jugadoresAptos.size() > 11
	}
	
	method jugadoresLesionados(){
		return self.todosLosJugadores().filter({unJugador => unJugador.estaLesionado()})
	}
	
	method jugadoresNoLesionados(){
		return self.todosLosJugadores().filter({unJugador =>not(unJugador.estaLesionado())})
	}
	
	method entrenar(){
		dt.entrenarJugadores(self.todosLosJugadores())
	}
	
	method recuperarFuerzas(){
		const bebidaAsignada = dt.bebidaDefinina()
		self.hidratarJugadores(self.jugadoresLesionados(),unaBebidaReparadora)
		self.hidratarJugadores(self.jugadoresNoLesionados(),bebidaAsignada)

	}
	
	method hidratarJugadores(unosJugadores,unaBebida){
		unosJugadores.forEach({unJugador => unJugador.hidratarse(unaBebida)})
	}
	
	
}



class Jugador{
	
	var property nombre
	var fechaNacimiento
	var property puntajeBase  = 0
	var property nivelEnergia = 0
	var property velocidad = 0
	var property estaLesionado = false
	
	method agregarEnergia(unaCantidad){
		nivelEnergia += unaCantidad
	}
	
	method agregarVelocidad(unaCantidad){
		velocidad += unaCantidad
	}
	
	method edad(){
		const diaHoy = new Date()
		return (diaHoy - fechaNacimiento) / 365
	}
	
	method puntosHabilidadEspecial(){
		return self.puntos()
	}
	
	method puntos()
	
	method habilidadTotal(){
		return puntajeBase + self.puntosHabilidadEspecial()
	}
	
	method entrenar(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento){
		if(self.puntosHabilidadEspecial() < 100 || cantidadTiempoEntrenamiento > 200)
		{
			self.lesionarse()
		}
	}
	
	method lesionarse(){
		self.estaLesionado(true)
		}
	
	method hidratarse(unaBebida){
		unaBebida.efecto(self)
	}	
	
}

class BebidaComun{
	
	var property cantidad
	
	method efecto(unJugador){
		unJugador.agregarEnergia(cantidad * 2)
	}
}

class BebidaEnergizante inherits BebidaComun{
	
	var property porcentajeAumento
	
	override method efecto(unJugador){
		super(unJugador)
		unJugador.agregarVelocidad(unJugador.velocidad() * porcentajeAumento)
		
	}
	
}

class BebidaReparadora inherits BebidaComun{
	
	override method efecto(unJugador){
		unJugador.estaLesionado(false)
	}
}

const unaBebidaReparadora = new BebidaReparadora(cantidad = 400)
const unaBebidaEnergizante = new BebidaEnergizante(cantidad = 350,porcentajeAumento = 0.2)
const unaBebidaComun = new BebidaComun(cantidad = 120)




class Correcaminos inherits Jugador{
	
	override method puntos(){
		return 3 * velocidad
	}
	
	override method entrenar(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento){
		super(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento)
		if(cantidadMetrosEntrenamiento > 6){
			velocidad += 1
		}
	}
}

class Pared inherits Jugador{
	
	var property nivelDureza
	
	override method puntos(){
		return (velocidad + nivelDureza + nivelEnergia) / 3
	}
	
	override method entrenar(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento){
		super(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento)
		if(nivelDureza <150){
			nivelDureza += 50
		}else{
			nivelDureza += 25
		}
	}
	
	
}

class Mago inherits Jugador{
	
	var property cantidadAcrobacias 
	
	override method puntos(){
		return cantidadAcrobacias * 20
	}
	
	override method entrenar(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento){
		if(cantidadTiempoEntrenamiento >100){
			cantidadAcrobacias = cantidadAcrobacias - cantidadAcrobacias/2
		}
		super(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento)
		cantidadAcrobacias =  cantidadAcrobacias + (cantidadTiempoEntrenamiento / 10)
	}
	
}

class DT{
	
	var property criterioDT
	var property cantidadTiempoEntrenamiento
	var property cantidadMetrosEntrenamiento
	var property puntosMinimosDeHabilidad
	var property bebidaDefinina 
	
	method seleccionarJugador(unJugador){
		return criterioDT.aceptacion(unJugador,puntosMinimosDeHabilidad)
	}
	
	method entrenarJugadores(unosJugadores){
		unosJugadores.forEach({unJugador => unJugador.entrenar(cantidadTiempoEntrenamiento,cantidadMetrosEntrenamiento)})
	}
}

object carusista{
	
	method aceptacion(unJugador,puntosMinimosDeHabilidad){
		return true
	}
}

object bilardista{
	
	
	method aceptacion(unJugador,puntosMinimosDeHabilidad){
		return unJugador.edad() > 23 && 
				unJugador.habilidadTotal() > puntosMinimosDeHabilidad
	}
}

object scalonista{
	
	method aceptacion(unJugador,puntosMinimosDeHabilidad){
		return unJugador.nivelEnergia() > 100 && 
				unJugador.nivelEnergia() > unJugador.puntosHabilidadEspecial()
	}
}


// Equipos

const sofi = new Correcaminos(nombre = "Sofia",fechaNacimiento = 2/03/1990)
const marcos = new Pared(nombre = "Marcos",fechaNacimiento = 1/01/1991,nivelDureza = 14)
const ale = new Mago(nombre = "Ale",fechaNacimiento = 2/02/1992,cantidadAcrobacias = 3)
const luli = new DT(criterioDT = bilardista,bebidaDefinina = unaBebidaComun, puntosMinimosDeHabilidad = 50,cantidadTiempoEntrenamiento = 80,cantidadMetrosEntrenamiento  = 2)

const equipo1 = new Equipo(dt = luli,jugadoresTitulares=[sofi,marcos,ale,luli])

const maria = new Correcaminos(nombre = "Maria",fechaNacimiento = 3/03/1993)
const martin = new DT(criterioDT = carusista,bebidaDefinina = unaBebidaEnergizante,puntosMinimosDeHabilidad = 80,cantidadTiempoEntrenamiento = 120,cantidadMetrosEntrenamiento  = 3)

const equipo2 = new Equipo(dt = martin,jugadoresTitulares=[maria])
