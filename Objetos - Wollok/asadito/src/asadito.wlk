class Persona{
	
	var property posicion = 3
	var property elementos = []
	var property criterioCambio = sordo
	var property criterioDeEleccionComida
	var property comidasDigeridas = []
	
	method pedirElementoA(persona,elemento){
		if(not(persona.tieneElElemento(elemento))){
			self.error("No tiene el elemento pedido")
		}else{
		persona.criterioCambio().pasarElemento(elemento,persona,self)
		}
	}
	
	method tieneElElemento(elemento){
		return elementos.contains(elemento)
	}
	
	method agregarElemento(elemento){
		elementos.add(elemento)
	}
	
	method eliminarElemento(elemento){
		elementos.remove(elemento)
	}
	
	method seleccionarComida(comida){
		if(criterioDeEleccionComida.puedeComer(comida)){
			comidasDigeridas.add(comida)
		}
	}
	
	method estaPipon(){
		comidasDigeridas.any({unaComida => unaComida.esPesada()})
	}
	
	method estaPasandolaBien(){
		return self.comioAlgo() && Moni.estuvoEnPos1() && Facu.comioCarne()
	}
	
	method estuvoEnPos1(){
		
	}
	
	method comioAlgo(){
		return comidasDigeridas.size() > 0
	}
		
}

const Osky = new Persona(posicion = 2,criterioDeEleccionComida = vegetariano)
const Moni = new Persona(posicion = 1,criterioDeEleccionComida = alternado)
const Facu = new Persona(posicion = 3,comidasDigeridas = [Lomo],criterioDeEleccionComida = dietetico)
const Vero = new Persona(posicion = 4,elementos = ["sal"],criterioDeEleccionComida = vegetariano)

// Punto 1

class CriterioDeCambio{
	
	method pasarElemento(elemento,persona1,persona2)
	
	
}

object sordo inherits CriterioDeCambio{
	
	override method pasarElemento(elemento,persona1,persona2){
		const elementoPasado =  persona1.elementos().first()
		persona2.agregarElemento(elementoPasado)
		persona1.eliminarElemento(elementoPasado)
	}
}

object todosLosElementos inherits CriterioDeCambio {
	
	override method pasarElemento(elemento,persona1,persona2){
		persona2.elementos().addAll(persona1.elementos())
		persona1.elemetos().clear()
	}
}

object cambiarPosicion inherits CriterioDeCambio{
	
	override method pasarElemento(elemento,persona1,persona2){
		self.intercambiarPosicion(persona1,persona2)
	}
	
	method intercambiarPosicion(persona1,persona2){
		const posAnterior = persona1.posicion()
		persona1.posicion(persona2.posicion())
		persona2.posicion(posAnterior)
		
	}
}

object cambioNormal inherits CriterioDeCambio{
	
	override method pasarElemento(elemento,persona1,persona2){
		persona1.eliminarElemento(elemento)
		persona2.agregarElemento(elemento)
		
	}
}

// Punto 2

class Comida{
	
	var property alimento 
	var property esCarne
	var property calorias
}

const Lomo = new Comida(alimento = "Lomo",esCarne = true,calorias = 120)

class CriterioDeEleccionComida{
	
	method puedeComer(comida)
}

object vegetariano{
	
	method puedeComer(comida){
		return not(comida.esCarne())
	}
}

object dietetico{
	
	method puedeComer(comida){
		return comida.calorias() < 500
	}
}

object alternado{
	
	var property criterioAnterior = true
	
	method puedeComer(comida){
		if(self.criterioAnterior()){
			criterioAnterior = false
			return criterioAnterior
		}else{
			criterioAnterior = true
			return criterioAnterior
		}
	}
}

object todasJuntas{
	
	var property criterios = [alternado,dietetico,vegetariano]
	
	method puedeComer(comida){
		return criterios.all({unCriterio => unCriterio.puedeComer(comida)})
	}
}
