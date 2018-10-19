
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

class Comerciante{

	var property tipoComerciante
	method precio(producto) = self.tipoComerciante().comision(producto) + producto.precio()

	method vende(personaje, artefacto) {
		if(self.loPuedeComprar(personaje,artefacto)){
			self.cobraPrecio(personaje,self.precio(artefacto))
			personaje.agregaArtefacto(artefacto)
		}
	}
	
	method canjea(personaje,hechizo){
		var nuevoPrecio = self.precioRetribuido(hechizo,personaje.hechizoPreferido())
		if(self.loPuedeCanjear(personaje,nuevoPrecio)){
			self.cobraPrecio(personaje, nuevoPrecio)
			personaje.hechizoPreferido(hechizo)	
		}
	}
	
	method cobraPrecio(personaje,precio) = personaje.paga(precio)
	method precioRetribuido(hechizoNuevo, hechizoViejo) = 0.max(hechizoNuevo.precio() - hechizoViejo.precio()/2)
	method loPuedeComprar(personaje,producto) = personaje.leAlcanza(producto.precio()) && personaje.podesLlevar(producto)
	method loPuedeCanjear(personaje,precio) =  personaje.leAlcanza(precio)
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
