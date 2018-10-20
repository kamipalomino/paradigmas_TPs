import rolando3.*

class HechizoComercial inherits Logos{
	var property porcentaje = 20
	override method poder() = self.nombre().size() * (self.porcentaje()/100) * self.multiplicador() 
}

object hechizoBasico {
	method peso() = 0
	method precio() = self.poder() 
	method precio(armadura) = self.poder() + armadura.precioBase() 
	method poder() = 10;
	method poder(personaje) = self.poder()
	method sosPoderoso() = false;
}
class LibroDeHechizos{  
	var property hechizos =  [ninguno];
	method precio() = 10*self.hechizos().size() + self.poder()
	method hechizos(nuevosHechizos) = self.hechizos().addAll(nuevosHechizos)
    method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})
    method sosPoderoso() = true //TODO el tp no especifica cuando es poderoso el libro
}
