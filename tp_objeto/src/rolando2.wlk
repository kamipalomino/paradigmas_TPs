// Deria cada hechizo, armadura, etc, saber su precio y la feria solo consultarlo o solo saberlo la feria, o ambos?
// Que debo definir como clase y como subtipo o herencia?
// con respecto a la armadura y sus refuerzos como manejar la ubicacion del precio?
class Personaje {

	var property nivelHechiceriaBase = 3;
	var property nivelLuchaBase = 1;
	var property monedas = 100;
	
	var property hechizoPreferido =  hechizoBasico;
	const property artefactos = [ninguno];

	method nivelHechiceria() = (self.nivelHechiceriaBase() * self.hechizoPreferido().poder(self)) + fuerzaOscura.poder();
	method sosPoderoso() = hechizoPreferido.sosPoderoso(self)

	method agregaArtefacto(artefacto) { self.agregaArtefactos([artefacto])}
	method agregaArtefactos(algunosArtefactos) {self.artefactos().addAll(algunosArtefactos)}
	method removeArtefacto(artefacto) { self.artefactos().remove(artefacto)}
	method removeTodosLosArtefactos() {
		self.artefactos().clear()
		self.agregaArtefacto(ninguno)
	}

	method nivelLucha() = self.artefactos().sum({artefacto => artefacto.poder(self)}) + self.nivelLuchaBase()
	method sosMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()
	method estasCargado() = self.artefactos().size() > 5
	
	method compra(artefacto) {feria.vende(self,artefacto)}
	method canjea(hechizo) = {feria.canjea(self,hechizo)}



}

//fuerza oscura
object fuerzaOscura {
	var property poder = 5

}

object luna{

	method eclipsate(){fuerzaOscura.poder(fuerzaOscura.poder()*2)}
}

// Hechizos -- definir hechizos como clase y luego tipos de hechizos?
class Logos {
	var property nombre = "";	// con property le puedo cambiar el nombre?	
	var property multiplicador = 1
 
    method poder() = self.nombre().size() * self.multiplicador();
	method poder(personaje) = self.poder()  // para poder usar polimorfismo uso poder(personaje)
	method precio() = self.poder() 
	method sosPoderoso() = return self.poder() > 15;
}

object hechizoBasico {
	method precio() = 10
	method poder() = 10;
	method poder(personaje) = self.poder();
	method sosPoderoso() = false;
}

//Artefactos
class ArmaDelDestino{
	method precio() = 5*self.poder()
	method poder() = 3
	method poder(personaje) = self.poder();
}

class CollarDivino{
	var property cantDePerlas = 5;
	method precio() = self.cantDePerlas() 
	method poder(personaje) = self.cantDePerlas();
}

class MascaraOscura{	
	var property indiceOscuridad = 0
	var property minimoPoder = 4
	method poder(personaje) = self.minimoPoder().max((fuerzaOscura.poder()/2)*self.indiceOscuridad());
}

class Armadura{
	var property poderBase = 2;
	var property refuerzo = ninguno;
	var property precioArmaduraBase = 2
	method precio() = self.precioArmaduraBase() + refuerzo.precio()
	method poder(personaje) = self.refuerzo().poder(personaje) + poderBase;
}

object espejoFantastico{	
	method poder(personaje) = self.ArtefactoMasFuerte(personaje).poder(personaje)
	method precio() = 90
	method ArtefactoMasFuerte(personaje) = self.listaConEspejoFiltrado(personaje.artefactos()).max({elemento => elemento.poder(personaje)})
	method listaConEspejoFiltrado(artefactos) = artefactos.filter({elemento => elemento != self})
}
//Refuerzos armadura

class CotaDeMalla{
	var property poder =  1
	method precio() = poder/2
	method poder(personaje) = poder
}
object bendicion{
	method precio() = 2 //FIXME debera ser el poderBase de la armadura
	method poder(personaje) =  personaje.nivelHechiceria();
}

object ninguno{
	method poder(personaje) =  0
	method precio() = 0
	method sosPoderoso() = false
}

//Libros de hechizos
class LibroDeHechizos{  //TODO libro tiene otro libro dentro
	var property hechizos =  [ninguno];
	method precio() = 10*self.hechizos().size() + self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})
	method hechizos(nuevosHechizos) = self.hechizos().addAll(nuevosHechizos)
    method poder(personaje) = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder(personaje)})
    method sosPoderoso() = true //TODO el tp no especifica cuando es poderoso el libro
}

object feria{
	method precio(producto) = producto.precio()
	
	method vende(personaje, artefacto) {
		self.cobraPrecio(personaje,artefacto.precio())
		personaje.agregaArtefacto(artefacto)
	}
	
	method canjea(personaje,hechizo){
		self.cobraPrecio(personaje,0.max(hechizo.precio() - personaje.hechizoPreferido().precio()))
		personaje.hechizoPreferido(hechizo)
	}
	
	method cobraPrecio(personaje,precio) = personaje.monedas(personaje.monedas()-precio)
}

//Tienda de Hechiceria
//object feriaHechiceria{	
//	method hechizoBasicoPrecio() = 10;
//	method hechizoLogos(hechizo) = hechizo.poder();
//	method armasDestinoPrecio(arma) =  arma.poder();
//	method collarDivinoPrecio() =  collarDivino.cantDePerlas();	
//	method armaduraConCotaPrecio(cotaDeMalla) = cotaDeMalla.poder() / 2;
//	method armaduraConBendicionPrecio(armadura) = armadura.poderBase();
//	method armaduraConHechizoPrecio(armadura) = armadura.poderBase() + armadura.refuerzo().precio();
//	method armaduraSinRefuerzoPrecio() =  2;
//	method armaduraPrecio(armadura) {
//		if(armadura.refuerzo() == cotaDeMalla){
//			return armaduraConCotaPrecio(armadura.refuerzo());
//		}
//		else if(armadura.refuerzo() == bendicion){
//			return  armaduraConBendicionPrecio(armadura);
//		}
//		else if(armadura.refuerzo() == Logos || armadura.refuerzo() == hechizoBasico){ // Hechizos -- definir hechizos como clase y luego tipos de hechizos?
//			return armaduraConHechizoPrecio(armadura);
//		}
//		else{
//			return armaduraSinRefuerzoPrecio();
//		}		
//	}
//	method espejoFantasticoPrecio() =  90;
//	method libroDeHechizosPrecio(libroDeHechizos) = libroDeHechizos.poder() + (10 * libroDeHechizos.hechizos().size());	
//}

