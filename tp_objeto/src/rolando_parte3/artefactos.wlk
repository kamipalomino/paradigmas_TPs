import personajes.*
import hechiceria.*
import comercio.*

class Artefacto{
	var property peso = 0
	const property fechaDeCompra = new Date()
	
	method peso() = peso - self.factorDeCorrecion()
	method factorDeCorrecion() = ((new Date() - self.fechaDeCompra()) /1000).min(1)
	method precio()
	method retribucion(unPersonaje) = 0
	method agrega(personaje) = personaje.agregaArtefacto(self)
}

class ArmaDelDestino inherits Artefacto{
	override method precio() = 5*self.peso()
	method poder() = 3
	method poder(personaje) = self.poder();
	
}

class CollarDivino inherits Artefacto{
	var property cantDePerlas = 5;
	var property pesoPerla = 0.5
	override method precio() = self.cantDePerlas() * 2
	method poder(personaje) = self.cantDePerlas();
	override method peso() = super() + self.pesoPerla()*self.cantDePerlas()
}

class MascaraOscura inherits Artefacto{
	var property indiceOscuridad = 1
	var property minimoPoder = 4
	method poder() = self.minimoPoder().max((fuerzaOscura.poder()/2)*self.indiceOscuridad());
	method poder(personaje) = self.poder()
	override method peso() = super() + (self.poder() - 3).max(0)
	override method precio() = 10*self.indiceOscuridad()
	
}
class CotaDeMalla{
	var property poder =  1
	method precio(armadura) = poder/2
	method poder(personaje) = poder
	method peso() = 1
	
}

object bendicion{
	method precio(armadura) = armadura.poderBase()
	method poder(personaje) =  personaje.nivelHechiceria();
	method peso() = 0
}


object sinRefuerzos{
	method poder(personaje) =  0
	method precio(armadura) = armadura.precioBase() 
	method peso() = 0
	method sosPoderoso() = false
}
class Armadura inherits Artefacto{
	var property poderBase = 2
	var property refuerzo = sinRefuerzos
	var property precioBase = 2
	override method precio() = self.refuerzo().precio(self)
	method poder(personaje) = self.refuerzo().poder(personaje) + poderBase;
	override method peso() = super()+ self.refuerzo().peso()
}



object espejoFantastico{
	method poder(personaje) = self.ArtefactoMasFuerte(personaje).poder(personaje)
	method precio() = 90
	method ArtefactoMasFuerte(personaje) = self.artefactos().max({elemento != self =>  elemento.poder(personaje)})
	method agrega(personaje) = personaje.agregaArtefacto(self)
	method retribucion(personaje) = 0
}
