
import artefactos.*
import hechiceria.*
import comercio.*


class Hechizos{
	var property porcentajeRetribucion = 0.5
	 method retribucion(personaje) = 0
	
}


class Logos inherits Hechizos  {
	var property nombre ;	// con property le puedo cambiar el nombre?	Si, podes :)
	var property multiplicador = 1	
 
 	method peso() = 2 - (self.poder()%2)
    method poder() = self.nombre().size() * self.multiplicador();
    method poder(personaje) = self.poder()
	method precio() = self.poder() 
	method precio(armadura) = self.poder() + armadura.precioBase()
	method sosPoderoso() = return self.poder() > 15;
	override method retribucion(unPersonaje) = unPersonaje.hechizoPreferido().precio() * self.porcentajeRetribucion()
	method agrega(personaje) = personaje.hechizoPreferido(self)
}

class HechizoComercial inherits Logos{
	var property porcentaje = 20
	override method poder() = self.nombre().size() * (self.porcentaje()/100) * self.multiplicador() 
}

object hechizoBasico  inherits Hechizos   {	
	method peso() = 0
	method precio() = self.poder() 
	method precio(armadura) = self.poder() + armadura.precioBase() 
	method poder() = 10;
	method poder(personaje) = self.poder()
	method sosPoderoso() = false;
	override method retribucion(unPersonaje) = unPersonaje.hechizoPreferido().precio() * porcentajeRetribucion
	method agrega(personaje) = personaje.hechizoPreferido(self)
	
}
class LibroDeHechizos inherits Hechizos  {  
	var property hechizos =  [];
	method precio() = 10*self.hechizos().size() + self.poder()
	method hechizos(nuevosHechizos) = self.hechizos().addAll(nuevosHechizos)
    method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})
    method sosPoderoso() = true 
    method agrega(personaje) = personaje.hechizoPreferido(self)   
}
