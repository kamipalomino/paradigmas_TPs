// Deria cada hechizo, armadura, etc, saber su precio y la feria solo consultarlo o solo saberlo la feria, o ambos?
// Que debo definir como clase y como subtipo o herencia?
// con respecto a la armadura y sus refuerzos como manejar la ubicacion del precio?
class Personaje {

	var property nivelHechiceriaBase = 3
	;
	var property nivelLuchaBase = 1
	;
	var property dineroBase = 100
	;
	var property hechizoPreferido = hechizoBasico
	;
	const property artefactos = [ ninguno ]

	;

	method nivelHechiceria() = (self.nivelHechiceriaBase() * self.hechizoPreferido().poder()) + fuerzaOscura.poder()

	;
	method sosPoderoso() = hechizoPreferido.esPoderoso()

	method agregaArtefacto(artefacto) {
		self.agregaArtefactos([ artefacto ])
	}

	method agregaArtefactos(algunosArtefactos) {
		self.artefactos().addAll(algunosArtefactos)
	}

	method removeArtefacto(artefacto) {
		self.artefactos().remove(artefacto)
	}

	method removeTodosLosArtefactos() {
		self.artefactos().clear()
		self.agregaArtefacto(ninguno)
	}

	method nivelLucha() = self.artefactos().sum({ artefacto => artefacto.poder() }) + self.nivelLuchaBase()

	method sosMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()

	method estasCargado() = self.artefactos().size() > 5

}

//fuerza oscura
object fuerzaOscura {

	var property poder = 5

}

object luna {

	method eclipsate() {
		fuerzaOscura.poder(fuerzaOscura.poder() * 2)
	}

}

// Hechizos -- definir hechizos como clase y luego tipos de hechizos?
class Logos {

	var property nombre = ""

	;	// con property le puedo cambiar el nombre?	
    method precio() = feriaHechiceria.hechizoBasicoPrecio()

	;
	method poder() = self.nombre().size()

	;
	method sosPoderoso() = return self.poder() > 15

	;
}

object hechizoBasico {

	method precio() = feriaHechiceria.hechizoLogos(self)

	;
	method poder() = 10

	;
	method sosPoderoso() = return self.poder() > 15

	;
}

//Artefactos
class ArmaDelDestino {

	method precio() = feriaHechiceria.armasDestinoPrecio(self)

	;
	method poder() = 3

	;
}

object collarDivino {

	var property cantDePerlas = 5

	;
	method poder() = self.cantDePerlas()

	;
}

class MascaraOscura {

	var property indiceOscuridad = 4

	;
	method poder() = (fuerzaOscura.poder() / 2).max(indiceOscuridad)

	;
}

class Armadura {

	var property poderBase = 2
	;
	var property refuerzo = ninguno

	;
	method poder() = self.refuerzo().poder() + poderBase

	method nuevoPoderBase() = new self.poderBase(nuevaBase)

	;
}

object espejoFantastico {

	var property quienLoPosee = new Personaje()

	;
	method poder() = quienLoPosee.artefactos().filter({ elemento => elemento != self }).max({ artefacto => artefacto.poder() }).poder()

}

//Refuerzos armadura
object cotaDeMalla {

	var property poder = 1

	;
	method poder() = self.poder()

}

object bendicion {

	var property quienLoPosee = new Personaje()

	;
	method poder() = quienLoPosee.nivelHechiceria()

	;
}

object ninguno {

	method poder() = 0

	;
	method sosPoderoso() = false

}

//Libros de hechizos
class LibroDeHechizos {

	method precio() = feriaHechiceria.libroDeHechizosPrecio(self)
	var property hechizos =  [ninguno];
	method hechizos(nuevosHechizos) = self.hechizos().addAll(nuevosHechizos)
    method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})
} //Tienda de Hechiceria
object feriaHechiceria {

	method hechizoBasicoPrecio() = 10

	;
	method hechizoLogos(hechizo) = hechizo.poder()

	;
	method armasDestinoPrecio(arma) = arma.poder()

	;
	method collarDivinoPrecio() = collarDivino.cantDePerlas()

	;	
	method armaduraConCotaPrecio(cotaDeMalla) = cotaDeMalla.poder() / 2

	;
	method armaduraConBendicionPrecio(armadura) = armadura.poderBase()

	;
	method armaduraConHechizoPrecio(armadura) = armadura.poderBase() + armadura.refuerzo().precio()

	;
	method armaduraSinRefuerzoPrecio() = 2

	;
	method armaduraPrecio(armadura) {
		if (armadura.refuerzo() == cotaDeMalla) {
			return armaduraConCotaPrecio
			(armadura.refuerzo())
		;
		} else if (armadura.refuerzo() == bendicion) {
			return armaduraConBendicionPrecio
			(armadura)
		;
		} else if (armadura.refuerzo() == Logos || armadura.refuerzo() == hechizoBasico) { // Hechizos -- definir hechizos como clase y luego tipos de hechizos?
			return armaduraConHechizoPrecio
			(armadura)
		;
		} else { return armaduraSinRefuerzoPrecio() }
	}

	method espejoFantasticoPrecio() = 90

	;
	method libroDeHechizosPrecio(libroDeHechizos) = libroDeHechizos.poder() + (10 * libroDeHechizos.hechizos().size())

	;	
}

