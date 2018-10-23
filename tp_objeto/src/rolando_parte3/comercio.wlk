import personajes.*
import artefactos.*
import hechiceria.*

class Comerciante{
	var property tipoComerciante
	
	method precio(producto) = self.tipoComerciante().comision(producto) + producto.precio()
	method vende(personaje, artefacto) = self.precio(artefacto))
	
	method canjea(personaje,hechizo)= self.precioRetribuido(hechizo,personaje.hechizoPreferido())
	
	method precioRetribuido(hechizoNuevo, hechizoViejo) = 0.max(hechizoNuevo.precio() - hechizoViejo.precio()/2)
	method recategorizate() = tipoComerciante.recategorizate(self)
	
}

class TipoComercianteIndependiente{
	var property porcentajeComision
	
	method porcentajeComision() = porcentajeComision
	method comision(producto) = self.porcentajeComision()/100 * producto.precio()
	method recategorizate(comerciante) = self.porcentajeComision((self.porcentajeComision()*2).min(21)) 
} 

object tipoComercianteRegistrado inherits TipoComercianteIndependiente{
	override method porcentajeComision() = 21
	override method recategorizate(comerciante) = comerciante.tipoComerciante(tipoComercianteImpuestoGanancia)
	
}

object tipoComercianteImpuestoGanancia{
	var property maximoNoImponible = 5
	var property porcentajeRecargo = 35
	
	method comision(producto) = self.diferenciaImportes(producto.precio())*self.porcentajeRecargo()/100
	method diferenciaImportes(precio) = 0.max(precio-self.maximoNoImponible())
	method recategorizate(comerciante){}
}

