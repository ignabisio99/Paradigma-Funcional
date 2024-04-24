// Las mensajerias

class Mensajeras{
	
	
	
	var property mensajesEnviados=0
	
	var property sector = enviosDefault
	
	method costoMensaje(mensaje){
		const cantidadPalabras = (mensaje.mensaje().words().size())
		return sector.calcularCosto(cantidadPalabras)
		 
	}
	
	
	method incrementarMensajes(){
		mensajesEnviados++
	}
	
	method puedeEnviar(mensaje){
		return mensaje.size()>=20
	}
	
	method transformarMensaje(unMensaje){
		const mensajeNuevo = new MensajeComun(mensaje = unMensaje)
		return mensajeNuevo
	}
	
}

class MensajeroParanoico inherits Mensajeras{
	
	override method transformarMensaje(unMensaje){
		const mensajeNuevo = new MensajeCifrado(mensaje = unMensaje)
		return mensajeNuevo.mensajeAEnviar()
	}
}

class MensajeroAlegre inherits Mensajeras{
	
	var property gradoAlegria
	
	override method transformarMensaje(unMensaje){
		if(gradoAlegria > 10){
			if(gradoAlegria.even()){
				const mensajeNuevo = 
					new MensajeCantado(mensaje = unMensaje,duracion = 6*gradoAlegria)
					return mensajeNuevo
				
				}else{
					const mensajeNuevo = new MensajeCantado(mensaje = unMensaje, duracion = 500)
					return mensajeNuevo
				
				}
		}else{
			const mensajeNuevo = new MensajeComun(mensaje = unMensaje)
			return mensajeNuevo
			
		}
	}
	
	
}

class MensajeroSerio inherits Mensajeras{
	
	 override method transformarMensaje(unMensaje){
		if(mensajesEnviados < 4){
			const mensajeNuevo = new MensajeElocuente(mensaje = unMensaje)
			return mensajeNuevo
		}else{
			const mensajeNuevo = new MensajeCifrado(mensaje = unMensaje)
			return mensajeNuevo
		}
	}
}

object chasqui inherits Mensajeras {
	
	
	
	override method puedeEnviar(mensaje) {
		return super(mensaje) && mensaje.size()<50
	}
	
	override method costoMensaje(mensaje){
		return 2*mensaje.mensaje().size()
		
	}
}

object sherpa inherits Mensajeras{
	
	var costoMensaje=60

	
	override method puedeEnviar(mensaje){
		return super(mensaje) && mensaje.size().even()
	}
	
	override method costoMensaje(mensaje){
		return costoMensaje
	}
	
	
}

object messich inherits Mensajeras {
	
	var multiplicador=10


	
	override method puedeEnviar(mensaje){
		return super(mensaje) && not(mensaje.startsWith("a"))
	}
	

	override method costoMensaje(mensaje){
		return	(mensaje.mensaje().words().size())*multiplicador
	}
	
}

object pali inherits Mensajeras{
	
	
	override method puedeEnviar(mensaje){
		var mensajeSinEspacios= mensaje.replace(" ","")
		return super(mensaje) && mensajeSinEspacios==mensajeSinEspacios.reverse()
	}
	
	override method costoMensaje(mensaje){
		var costoMensajeParcial = 4*mensaje.mensaje().size()
		return costoMensajeParcial.min(80)
	}
	
}

object pichca inherits Mensajeras{
	

	const valoresAzar=[3,4,5,6,7]
	
	
	override method puedeEnviar(mensaje){
		return super(mensaje) && (mensaje.words().size())>3
	}
	
	override method costoMensaje(mensaje){
		return (mensaje.mensaje().size())*(valoresAzar.anyOne())
	}
	
}

// Mensajer@ Estandar

/*class MensajeroEstandar inherits Mensajeras{
	

	
	override method costoMensaje(mensaje){
		const cantidadPalabras = (mensaje.words().size())
		return new Sectores().calcularCosto(cantidadPalabras,sector.cobra())
		 
	}
	
}*/

const enviosRapidos = new Sectores(cobra = 20)
	
const enviosEstandares = new Sectores(cobra = 15)

const enviosVIP = new Sectores(cobra=30)

const enviosDefault = new Sectores(cobra = 1)

class Sectores{
	var property cobra
	
	
	method calcularCosto(cantidadPalabras){
		return cantidadPalabras*cobra
	}
}

// Agencia de mensajeria

object agenciaDeMensajeria{
	
	var property mensajeros=[chasqui,sherpa,messich,pali]
	var property mensajerosReceptores=[]
	var property mensajesRecibidos=[]
	var property dineroAPagar=0
	method aQuienPedirle(mensaje){
		var mensajerosFiltrados=mensajeros.filter({unMensajero=>unMensajero.puedeEnviar(mensaje)})
		return mensajerosFiltrados.min({unMensajero=>unMensajero.costoMensaje(unMensajero.transformarMensaje(mensaje))})
		
	}
	
	method mensajeVacio(mensaje){
		return mensaje.size() ==0
	}
	
	method recibirMensaje(mensaje){
		if(self.mensajeVacio(mensaje)){
			self.error("No se puede recibir el mensaje")
		}
		if(mensajeros.filter({unMensajero=>unMensajero.puedeEnviar(mensaje)})==[]){
			self.error("Nadie puede enviar este mensaje")
		}
		var mensajeroReceptor=self.aQuienPedirle(mensaje)
		var mensajeTransformado = mensajeroReceptor.transformarMensaje(mensaje)
		mensajerosReceptores.add(mensajeroReceptor)
		mensajesRecibidos.add(mensajeTransformado)
		dineroAPagar+=mensajeroReceptor.costoMensaje(mensajeTransformado)
		mensajeroReceptor.incrementarMensajes()
	}
	
	
	method gananciaNeta(){
		var mensajesCortos=mensajesRecibidos.filter({unMensaje=>unMensaje.mensaje().size()<30})
		
		var mensajesLargos=mensajesRecibidos.size() - mensajesCortos.size()
		return 500*mensajesCortos.size()+900*mensajesLargos-self.dineroAPagar()
	}
	
	method chasquiQuilla(){
		return mensajeros.max({unMensajero=>unMensajero.mensajesEnviados()})
	}
	
}

// Los mensajes


class MensajeComun{
	
	var property mensaje
	
	method ganancia(){
		if (mensaje.size() <30){
			return 500
		}else{
			return 900
		}
	}
	
	method costoMensaje(){
		return 0
	}
}

class MensajeCantado inherits MensajeComun{
	
	var property duracion
	
	
	method costoMensaje(costo){
		return costo*0.10
	}
	
	
}

class MensajeElocuente inherits MensajeComun{
	
	method gradoElocuencia(){
		const cantidadMonosilabos = mensaje.words().count({unaPalabra => unaPalabra.size() < 3})
		return 1 + cantidadMonosilabos
	}
	
	override method ganancia(){
		return self.gradoElocuencia() * super()
	}
	
}

class MensajeCifrado inherits MensajeComun{
	
	method mensajeAEnviar(){
		return mensaje.reverse()
	}
	
	override method costoMensaje(){
		return 3* mensaje.indexOf("a")
	}
	
	
}
