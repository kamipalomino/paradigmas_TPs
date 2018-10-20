
class Personaje {

	var property nivelHechiceriaBase = 3;
	var property nivelLuchaBase = 1;
	var property monedas = 100;
	const property pesoMaximo = 200
	
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
	
	method podesLlevar(artefacto) = 0 <= (self.pesoMaximo() - (artefacto.peso() + self.cuantoPesoTenes()))
	method cuantoPesoTenes() = self.artefactos().sum({artefacto => artefacto.peso()})
	method tenes(artefacto) = self.artefactos().contains(artefacto)

	method cantidadDeArtefactos() = self.artefactos().size() - 1 //le resto el objeto ninguno
	method nivelLucha() = self.artefactos().sum({artefacto => artefacto.poder(self)}) + self.nivelLuchaBase()
	method sosMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()
	method estasCargado() = self.artefactos().size() > 5
	method leAlcanza(precio) = self.monedas() > precio
	
	method paga(precio) =  self.monedas(self.monedas()-precio)
	method compra(comerciante,artefacto) = comerciante.vende(self,artefacto)
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


class Logos {
	var property nombre = "";	
	var property multiplicador = 1
 
 	method peso() = 2 - (self.poder()%2)
    method poder() = self.nombre().size() * self.multiplicador();
    method poder(personaje) = self.poder()
	method precio() = self.poder() 
	method precio(armadura) = self.poder() + armadura.precioBase()
	method sosPoderoso() = return self.poder() > 15;
}

