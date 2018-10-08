// Deria cada hechizo, armadura, etc, saber su precio y la feria solo consultarlo o solo saberlo la feria, o ambos?
// Que debo definir como clase y como subtipo o herencia?
// con respecto a la armadura y sus refuerzos como manejar la ubicacion del precio?
// como hago para no necesitar el objeto 'ninguno' en artefactos, por el tema del espejoPreferido
// test 4 de luchaAvanzada no da bien, ni idea porque

class Personaje {

	var property nivelHechiceriaBase = 3;
	var property nivelLuchaBase = 1;
	var property monedas = 100;
	
	var property hechizoPreferido =  hechizoBasico;
	const property artefactos = [ninguno];

	method nivelHechiceria() = (self.nivelHechiceriaBase() * self.hechizoPreferido().poder()) + fuerzaOscura.poder();
	method sosPoderoso() = hechizoPreferido.sosPoderoso(self)

	method agregaArtefacto(artefacto) { self.agregaArtefactos([artefacto])}
	method agregaArtefactos(algunosArtefactos) {self.artefactos().addAll(algunosArtefactos)}
	method removeArtefacto(artefacto) { self.artefactos().remove(artefacto)}
	method removeTodosLosArtefactos() {
		self.artefactos().clear()
		self.agregaArtefacto(ninguno)
	}
	
	method tiene(artefacto) = self.artefactos().contains(artefacto)

	method cantidadDeArtefactos() = self.artefactos().size() - 1 //le resto el objeto ninguno
	method nivelLucha() = self.artefactos().sum({artefacto => artefacto.poder(self)}) + self.nivelLuchaBase()
	method sosMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()
	method estasCargado() = self.artefactos().size() > 5
	
	method compra(artefacto){ feria.vende(self,artefacto)}
	method canjea(hechizo){feria.canjea(self,hechizo)}



}

//fuerza oscura
object fuerzaOscura {
	var property poder = 5

}

object luna{

	method eclipsate() = fuerzaOscura.poder(fuerzaOscura.poder()*2)
}

// Hechizos -- definir hechizos como clase y luego tipos de hechizos?
class Logos {
	var property nombre = "";	// con property le puedo cambiar el nombre?	Si, podes :)
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
	method precio() = self.cantDePerlas() * 2
	method poder(personaje) = self.cantDePerlas();
}

class MascaraOscura{
	var property indiceOscuridad = 0
	var property minimoPoder = 4
	method poder() = self.minimoPoder().max((fuerzaOscura.poder()/2)*self.indiceOscuridad());
	method poder(personaje) = self.poder()
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
	method precio() = poder/2 - (new Armadura().precioArmaduraBase())
	method poder(personaje) = poder
}
object bendicion{
	method precio() = 0 //FIXME debera ser el poderBase de la armadura
	method poder(personaje) =  personaje.nivelHechiceria();
}

object ninguno{
	method poder(personaje) =  0
	method precio() = 0
	method sosPoderoso() = false
}

class LibroDeHechizos{  
	var property hechizos =  [ninguno];
	method precio() = 10*self.hechizos().size() + self.poder()
	method hechizos(nuevosHechizos) = self.hechizos().addAll(nuevosHechizos)
    method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})
    method sosPoderoso() = true //TODO el tp no especifica cuando es poderoso el libro
}

object feria{

	method precio(producto) = producto.precio()

	method vende(personaje, artefacto) {
		if(self.loPuedeComprar(personaje, artefacto.precio())){
			self.cobraPrecio(personaje,artefacto.precio())
			personaje.agregaArtefacto(artefacto)
		}
	}
	
	method canjea(personaje,hechizo){
		var nuevoPrecio = self.precioRetribuido(hechizo,personaje.hechizoPreferido())
		if(self.loPuedeComprar(personaje,nuevoPrecio)){
			self.cobraPrecio(personaje, nuevoPrecio)
			personaje.hechizoPreferido(hechizo)	
		}
	}
	
	method cobraPrecio(personaje,precio) = personaje.monedas(personaje.monedas()-precio)
	method precioRetribuido(hechizoNuevo, hechizoViejo) = 0.max(hechizoNuevo.precio() - hechizoViejo.precio()/2)
	method loPuedeComprar(personaje,precio) = personaje.monedas() > precio 
	
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

