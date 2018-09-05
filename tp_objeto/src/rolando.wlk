//preguntar
//no repetir codigo en el test
//objeto luna para eclipse

object rolando {
	
	var property nivelHechiceriaBase = 3;
	var property nivelLuchaBase = 1;
	var property hechizoPreferido =  espectroMalefico;
	const property artefactos = [ninguno];		
	
	method nivelHechiceria() = (self.nivelHechiceriaBase() * self.hechizoPreferido().poder()) + fuerzaOscura.poder();
	method sosPoderoso() = hechizoPreferido.esPoderoso()
	
	method agregaArtefacto(artefacto) { self.agregaArtefactos([artefacto])}
	method agregaArtefactos(algunosArtefactos) {self.artefactos().addAll(algunosArtefactos)}
	method removeArtefacto(artefacto) { self.artefactos().remove(artefacto)}
	method removeTodosLosArtefactos() { 
		self.artefactos().clear()
		self.agregaArtefacto(ninguno)
	}
	
	method nivelLucha() = self.artefactos().sum({artefacto => artefacto.poder()}) + self.nivelLuchaBase()
	method sosMejorEnLucha() = self.nivelLucha() > self.nivelHechiceria()
	method estasCargado() = self.artefactos().size() > 5
	
	
}

//fuerza oscura
object fuerzaOscura {
	var property poder = 5 
	
}

object luna{
	
	method eclipsate(){fuerzaOscura.poder(fuerzaOscura.poder()*2)}
}


// Hechizos
object espectroMalefico {	
	var property nombre = "Espectro maléfico";
	
	method poder() = self.nombre().size();	
	method sosPoderoso() = return self.poder() > 15;
}

object hechizoBasico {	
	method poder() = 10;	
	method sosPoderoso() = return self.poder() > 15;
}

//Artefactos
object espadaDelDestino{
	method poder() = 3;
}

object collarDivino{
	
	var property cantDePerlas = 5	
	method poder() = self.cantDePerlas();
}

object mascaraOscura{
	method poder() =  (fuerzaOscura.poder()/2).max(4);
}
object armadura{
	var property refuerzo = cotaDeMalla;
	method poder() = self.refuerzo().poder() + 2;
}

object espejoFantastico{
	method poder() = rolando.artefactos().filter({elemento => elemento != self})
	.max({artefacto => artefacto.poder()}).poder()

}
//Refuerzos armadura
object cotaDeMalla{
	method poder() =  1;
}
object bendicion{
	method poder() =  rolando.nivelHechiceria();
}

object ninguno{
	method poder() =  0;
	method sosPoderoso() = false
}

//Libros de hechizos
object libroDeHechizos{ 
	var property hechizos =  [ninguno];
	method hechizos(nuevosHechizos) = self.hechizos().addAll(nuevosHechizos)
    method poder() = self.hechizos().filter({hechizo => hechizo.sosPoderoso()}).sum({hechizo => hechizo.poder()})	
}
