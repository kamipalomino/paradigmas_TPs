//preguntar
//no repetir codigo en el test
//objeto luna para eclipse

object rolando {
	
	const nivelHechiceriaBase = 3;
	var nivelLuchaBase = 1;
	var hechizoPreferido =  espectroMalefico;
	const artefactos = [];
			
	
	method hechizoPreferido() = hechizoPreferido;	
	method hechizoPreferido(nuevoHechizo) { hechizoPreferido = nuevoHechizo};
	
	method nivelHechiceria() = (nivelHechiceriaBase * hechizoPreferido.poder()) + fuerzaOscura.valor();
	method esPoderoso() = hechizoPreferido.esPoderoso()
	
	
	method nivelLuchaBase(nivel) { nivelLuchaBase = nivel}
	
	method artefactos() = artefactos
	method agregaArtefacto(artefacto) { self.agregaArtefactos([artefacto])}
	method agregaArtefactos(algunosArtefactos) {artefactos.addAll(algunosArtefactos)}
	method removeArtefacto(artefacto) { artefactos.remove(artefacto)}
	method removeTodosLosArtefactos() { artefactos.clear()}
	
	method nivelLucha() = artefactos.sum({artefacto => artefacto.unidadesDeLucha()}) + nivelLuchaBase
	method esMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()
	method estaCargado() = artefactos.size() >= 5
	
	
}

//fuerza oscura
object fuerzaOscura {
	
	var valor = 5 
	
	method valor() = valor
	method valor(valorNuevo) {valor = valorNuevo}
}

object luna{
	
	method eclipsate(){fuerzaOscura.valor(fuerzaOscura.valor()*2)}
}


// Hechizos
object espectroMalefico {	
	var nombre = "Espectro maléfico";
	
	method nombre(nuevoNombre) { nombre = nuevoNombre};
	method poder() = nombre.size();	
	method esPoderoso() = return self.poder() > 15;
}

object hechizoBasico {	
	method poder() = 10;	
	method esPoderoso() = return self.poder() > 15;
}

//Artefactos
object espadaDelDestino{
	
	method unidadesDeLucha() = 3;
}
object collarDivino{
	
	var cantDePerlas = 5
	
	method cantDePerlas(cantidad) {cantDePerlas = cantidad}
	method unidadesDeLucha() = cantDePerlas;
}

object mascaraOscura{
	method unidadesDeLucha() =  (fuerzaOscura.valor()/2).max(4);
}
object armadura{
	var refuerzo = cotaDeMalla;
	method refuerzo(nuevoRefuerzo) {refuerzo = nuevoRefuerzo}
	method unidadesDeLucha() = refuerzo.unidadesDeLucha() + 2;
}

object espejoFantastico{
	method unidadesDeLucha() = self.listaSinEspejo(rolando.artefactos()).max({artefacto => artefacto.unidadesDeLucha()}).unidadesDeLucha()
	method listaSinEspejo(lista) = lista.filter({elemento => elemento != self})

}
//Refuerzos armadura
object cotaDeMalla{
	method unidadesDeLucha() =  1;
}
object bendicion{
	method unidadesDeLucha() =  rolando.nivelHechiceria();
}
object hechizo{
	var hechizo = hechizoBasico
	method hechizo(unHechizo) {hechizo = unHechizo}
	method unidadesDeLucha() =  hechizo.poder();
}
object ninguno{ //es realmente necesario este?
	method unidadesDeLucha() =  0;
}
//Libros de hechizos
object libroDeHechizos{ //es realmente necesario este?
	var hechizos =  [];
	method hechizos(nuevosHechizos) = [hechizos.addAll(nuevosHechizos)]
    method poder() = hechizos.filter({hechizo => hechizo.esPoderoso()}).sum({hechizo => hechizo.poder()})	
}
