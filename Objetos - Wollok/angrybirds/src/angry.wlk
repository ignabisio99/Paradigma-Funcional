// Cuidado con los pajaros

class Isla{
	
	var property pajaros = []
	
	method pajarosMasFuertes(){
		return pajaros.filter({unPajaro => unPajaro.fuerza() >50 })
	}
	
	method fuerzaIsla(){
		const pajarosFuertes = self.pajarosMasFuertes()
		return pajarosFuertes.sum({unPajaro => unPajaro.fuerza()})
	}
	
	method sesionDeManejo(){
		pajaros.forEach({unPajaro => unPajaro.tranquilizar()})
	}
	
	method invasionCerdos(cantidadCerdos){
		const vecesARepetir = cantidadCerdos / 100
		pajaros.forEach({unPajaro => vecesARepetir.times({i=>unPajaro.enojarse()})})
	}
	
	method fiestaSopresa(pajarosSeleccionados){
		const parajosEnLaIsla = pajarosSeleccionados.filter({unPajaro => pajaros.contains(unPajaro)})
		if(parajosEnLaIsla == []){
			self.error("No hay pajaros para homenajear")
		}else{
		parajosEnLaIsla.forEach({unPajaro => unPajaro.enojarse()})
		}
		}
	
	method eventosDesafortunados(cantidadCerdos,pajarosSeleccionados){
		self.sesionDeManejo()
		self.invasionCerdos(cantidadCerdos)
		self.fiestaSopresa(pajarosSeleccionados)
	}
	
	method atacarIsla(isla){
		
	}
}

class PajaroComun{
	
	var property ira
	
	method fuerza(){
		return ira * 2
	}
	 
	method duplicarIra(){
	 	ira += ira
	 }
	
	method enojarse(){
		self.duplicarIra()
	} 	
	
	method tranquilizar(){
		ira -= 5
	}
	
	method puedeDerribar(obstaculo){
		return self.fuerza() > obstaculo.resistencia()
	}
}

class PajaroRencoroso inherits PajaroComun{
	
	var property cantidadEnojos = 0
	override method enojarse(){
		self.duplicarIra()
		cantidadEnojos += 1
	}
}

object red inherits PajaroRencoroso(ira = 100){
	
	override method fuerza(){
		return self.ira() * 10 * self.cantidadEnojos()
	}
	
	
}

object bomb inherits PajaroComun(ira = 40){
	
	var property fuerzaMax = 9000
	
	override method fuerza(){
		return (2 * ira).min(fuerzaMax)
	}
}

object chuck inherits PajaroComun(ira = 20){
	
	var property velocidadActual = 100
	
	override method fuerza(){
		if(velocidadActual <= 80 ){
			return 150
		}else{
			return 150 + 5 * velocidadActual - 80
		}
	}
	
	override method tranquilizar(){
		
	}
}

object terence inherits PajaroRencoroso(ira = 10){
	
	const multiplicador = 4
	
	override method fuerza(){
		return super() * multiplicador
	}
}

object matilda inherits PajaroComun(ira = 40){
	
	var huevos = []
	
	override method fuerza(){
		return 2 * ira + huevos.sum({unHuevo => unHuevo.peso()})
	}
	
	override method enojarse(){
		super()
		self.ponerUnHuevo()
	}
	
	method ponerUnHuevo(){
		const nuevoHuevo = new Huevo(peso = 2)
		huevos.add(nuevoHuevo)
	}
}

class Huevo{
	
	var property peso
}

class IslaCerdo{
	
	var property obstaculos = []
}

class Pared{
	
	var tipo
	var ancho
	
	method resistencia(){
		return tipo.resistencia() * ancho
	}
}

object vidrio{
	
	var property resistencia = 10
}

object madera{
	
	var property resistencia = 25
}

object piedra{
	
	var property resistencia = 50
}

object cerdoObrero{
	
	var property resistencia = 50
}

object cerdoArmado{
	
	var defensa
	
	method resistencia(){
		return 10 * defensa.resistencia()
	}
}

object casco{
	
	var property resistencia
}

object escudo{
	
	var property resistencia
}