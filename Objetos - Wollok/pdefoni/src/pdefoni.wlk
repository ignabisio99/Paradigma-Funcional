// Linea de telefono

class Linea{
	
	var numero
	var packs = []
	var property deuda = 0
	const consumos = []
	var property tipoLinea = lineaDefault
	
	method agregarConsumo(consumo){
		consumos.add(consumo)
	}
	
	method agregarPack(pack){
		packs.add(pack)
	}
	
	method consumoTotal(lista){
		return lista.sum({unConsumo => unConsumo.costoConsumo()})
	}
	
	method cantidadConsumos(lista){
		return lista.size()
	}
	
	method consumoEntre(fecha1,fecha2){
		const consumosDias = consumos.filter({unConsumo => unConsumo.consumidoEntre(fecha1,fecha2)})
		return consumosDias
	}
	
	method calcularPromedio(lista){
		return self.consumoTotal(lista)/self.cantidadConsumos(lista)
	}
	
	method calcularPromediosEntreDias(fecha1,fecha2){
		const consumosDias = self.consumoEntre(fecha1,fecha2)
		return self.calcularPromedio(consumosDias)
	}
	
	method consumoTotal30(){
		const fecha = new Date()
		const consumosDias = self.consumoEntre(fecha,fecha.plusDay(30))
		return self.consumoTotal(consumosDias)
	}
	
	method puedeHacerConsumo(consumo){
		return packs.any({unPack => unPack.consumoCubre()})
	}
	
	method consumirLinea(consumo){
		const packPosibles = packs.filter({unPack => unPack.consumoCubre()})
		if (packPosibles == []){
			
			tipo.manjearError(self,deuda)
		}
		const packSeleccionado = packPosibles.last()
		packSeleccionado.consumir(consumo.cantidad())
		consumos.agregarConsumo(consumo)
	}
	
	method limpieza(){
		packs.removeAllSuchThat({unPack =>not(unPack.fechaVigente()) || unPack.cantidad() <= 0})
	}
	
	method aumentarDeuda(costo){
		deuda += costo
	}
}

object lineaDefault{
	
	method manjearError(linea,deuda){
		self.error("Ningun pack puede consumir")
	}
}

object lineaBlack{
	
	method manejarError(linea,constoDelConsumo){
		linea.aumentarDeuda(constoDelConsumo)
	
	}
}

object lineaPlatium{
	
	method manejarError(linea,costo){
		
	}
}

class Consumo{
	
	var property cantidad	

	const property fechaRealizado = new Date()
	
	method consumidoEntre(fecha1,fecha2){
		return fechaRealizado.between(fecha1,fecha2)
	}
	
	method cubreLlamadas(pack) = false
	
	method cubreInternet(pack) = false
	
	
}

class ConsumoInternet inherits Consumo{
	
	
	method cantidad(){
		return cantidad
	}
	
	
	method costoInternet(){
		return cantidad* 0.10
	}
	
	override method cubreInternet(pack){
		return pack.puedeCubrir(cantidad)
	}
}
	

class ConsumoLlamada inherits Consumo{
	
	
	method cantidad(){
		return cantidad
	}
	
	method costoLlamada(){
		return 1+(cantidad.max(30) - 30) * 0.5
	}	
	
}

class Pack{
	
	var fechaVencimiento = new Date()
	
	var cantidad
	
	
	method consumir(megas){
		cantidad -= megas
	}
	
	method puedeSatisfacer(consumo){
		return self.fechaVigente() && self.consumoCubre(consumo)
	}
	
	method consumoCubre(consumo)
	
	method fechaVigente(){
		const fechaActual = new Date()
		return fechaActual < fechaVencimiento
	}
	
}


class PackMBLibres inherits Pack{
	
	
	method puedeCubrir(megas){
		return cantidad > megas
	}
	
	override method consumoCubre(consumo){
		consumo.cubreInternet(consumo)
	}
}

class PackCredito inherits Pack{
	
	override method consumoCubre(consumo){
	  return cantidad > consumo.costoConsumo()
	}
}

class PackMBMasMas inherits PackMBLibres{
	
	override method puedeCubrir(megas){
		if(cantidad < megas){
			return megas <= 0.1
		}else{
			return super(megas)
		}
	}
}

