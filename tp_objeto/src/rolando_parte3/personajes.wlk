import personajes.*
import artefactos.*
import hechiceria.*
import comercio.*

class Personaje {
	
	var property nivelHechiceriaBase = 3;
	var property nivelLuchaBase = 1;
	var property monedas = 100;
	const property pesoMaximo = 200
	
	var property hechizoPreferido =  hechizoBasico;
	const property artefactos = [];

	method nivelHechiceria() = (self.nivelHechiceriaBase() * self.hechizoPreferido().poder()) + fuerzaOscura.poder();
	method sosPoderoso() = hechizoPreferido.sosPoderoso(self)

	method agregaArtefacto(artefacto) { self.agregaArtefactos([artefacto])}
	method agregaArtefactos(algunosArtefactos) {self.artefactos().addAll(algunosArtefactos)}
	method removeArtefacto(artefacto) { self.artefactos().remove(artefacto)}
	method removeTodosLosArtefactos() {
		self.artefactos().clear()
		
	}
	
	method podesLlevar(artefacto) = 0 <= (self.pesoMaximo() - (artefacto.peso() + self.cuantoPesoTenes()))
	method cuantoPesoTenes() = self.artefactos().sum({artefacto => artefacto.peso()})
	method tenes(artefacto) = self.artefactos().contains(artefacto)

	method cantidadDeArtefactos() = self.artefactos().size()
	method nivelLucha() = self.artefactos().sum({artefacto => artefacto.poder(self)}) + self.nivelLuchaBase()
	method sosMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()
	method estasCargado() = self.artefactos().size() > 5
	method leAlcanza(precio) = self.monedas() > precio
	
	method paga(precio) =  self.monedas(self.monedas()-precio)
	method compra(comerciante,artefacto) {
		if(!self.leAlcanza(precio(artefacto))&& !self.podesLlevar(artefacto)){
			throw new Exception("No podes comprar man!")
		} 
		comerciante.vende(self,artefacto) && self.agregaArtefacto(artefacto)
	}
	method canjea(comerciante,hechizo) = comerciante.canjea(self,hechizo)
}

class NPC inherits Personaje{
	var property dificultad = facil 
	override method nivelLucha() = super() * self.dificultad().valor()
}
object facil{
	const property valor = 1
}

object moderado{
	const property valor = 2
}

object dificil{
	const property valor = 4
}

//fuerza oscura
object fuerzaOscura {
	var property poder = 5

}

object luna{

	method eclipsate() = fuerzaOscura.poder(fuerzaOscura.poder()*2)
}
