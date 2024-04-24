object sistema{
	
}

class Alquiler{
	
	var property cantidadMeses
	var property valorInmueble
	
	method comisionAgente(inmueble){
		return cantidadMeses * inmueble.valor() / 50000
	}
}

class Venta{
	
	var property valorInmueble
	var property porcentajeComision
	
	
	method comisionAgente(inmueble){
		return inmueble.valor() * porcentajeComision / 100
	}
}

class Inmueble{
	
	var property valor
	var property tamanoMetrosCuadrados
	var property cantidadAmbientes
	var property tipoPublicacion
	var property plusZona
	var clienteReservado
	var reservado = false
	var comprado = false
	
	method reservar(unCliente){
		reservado = true
		clienteReservado = unCliente
	}
	
	method estaReservado(){
		return reservado
	}
	
	method comprar(){
		comprado = true
	}
		
	
	method valorParticular()
	
	

}

class Casa inherits Inmueble{
	
	var valorParticular
	
	override method valorParticular(){
		return valorParticular * self.plusZona()
	}
}

class PH inherits Inmueble{
	
	override method valorParticular(){
		return (14000 * self.tamanoMetrosCuadrados()).max(500000) * self.plusZona()
	}
}

class Depto inherits Inmueble{
	
	override method valorParticular(){
		return 350000 * self.cantidadAmbientes() * self.plusZona()
	}
}

class Empleado{
	
	const operaciones = []
	
	method realizarReserva(inmueble,unCliente){
		if(not(inmueble.estaReservado())){
			inmueble.reservar(unCliente)
		}else{
			self.error("No se puede reservar esta propiedad")
		}
	}
	
	
	method concretarOperacion(inmueble,unCliente){
		if(not(inmueble.estaReservado()) || inmueble.clienteReservado() === unCliente){
			inmueble.comprar()
		}else{
			self.error("No se puede comprar esta propiedad")
		}
	}
	
}

class Cliente{
	
	var property nombre
	
	method solicitarReserva(empleado,inmueble){
		empleado.realizarReserva(inmueble)
	}
}