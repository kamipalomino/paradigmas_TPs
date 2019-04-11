# paradigmas_TPs
#Lógico 

https://docs.google.com/document/d/1zEWqw1M1wiZpKjSjvVd_FdV9yVrXW9Ks2xN7smN3icI/edit#

<Spoiler Alert>
Lamentablemente, existe gente mala en el mundo, ese tipo de personas que spoilean una buena serie, ya sea por diversión o distracción. También existen los trolls, que son aquellos que dan falsos spoilers para arruinarte la vida hasta que compruebes que fue todo una gran mentira.

Es por este motivo que hemos decidido realizar un programa en el Paradigma Lógico, en el lenguaje Prolog, para poder adentrarnos más en el mundo de los Spoilers y saber realmente cuándo debemos matar a alguien o no.
“...Porque el TP es largo, y está lleno de spoilers”



1 Punto A: Quién mira qué
Sabemos que 
Juan mira “How I met your mother”, “Futurama” y “Game of Thrones”
Nadie mira “Mad men”
A Star Wars la miran Nico y Maiu
Maiu ve “One Piece” y “Game of Thrones”
Nico ve “Game of Thrones” 
Gastón está viendo “House of Cards”
Alf no ve ninguna serie porque el doctorado le consume toda la vida

Además sabemos que las series “Game of Thrones”, “House of Cards” y “Star Wars” son populares.

También queremos registrar las series que la gente planea ver. Por ejemplo:
Juan quiere ver “House of Cards”
Aye quiere ver “Game of Thrones”
Gastón quiere ver “How I met your mother”

Por último queremos registrar de cada serie, cuántos episodios tiene cada temporada. Por ejemplo:
“Game of Thrones” tiene 12 episodios la temporada 3 y 10 la segunda temporada.
“How I met your mother” tiene 23 episodios la temporada 1
“Dr. House” tiene 16 episodios la temporada 8
No recordamos cuántos episodios tiene la segunda temporada de “Mad men”

Definir la base de conocimientos y, en caso de no implementar nada, justificar qué concepto entra en juego. 

Nota: Para identificar a las series mencionadas anteriormente usar los siguientes nombres: himym, starWars, got, futurama, hoc, onePiece, drHouse, madMen.

2 Anexo: Lo que pasó, pasó
Registramos las cosas importantes que pasaron en distintas series, que puede ser:
Un personaje muere
Se devela una relación de una determinada naturaleza entre dos personas

En este caso proveemos la base de conocimientos que deben agregar:

%paso(Serie, Temporada, Episodio, Lo que paso)
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).


También queremos relacionar una persona con otra y algo que supuestamente pasó en una serie que la otra persona no sabía:

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)). 
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

3 Punto B: Es spoiler
Implementar el predicado esSpoiler/2 que relaciona una serie y un posible spoiler, que se cumple si efectivamente pasó (claro, tiene que morir ese personaje, o darse esa relación entre esos personajes concretos).

Por ejemplo: 
es cierto que la muerte de Emperor para Star Wars es un spoiler. 
no es cierto que la muerte de Pedro sea un spoiler para Star Wars.
es cierto que la relación de parentesco entre Anakin y el Rey es un spoiler para Star Wars
no es cierto que la relación de padre entre Anakin y Lavezzi sea un spoiler para Star Wars


¿Qué tipo de consultas (existenciales o individuales) pueden hacerse a la base de conocimientos? Justificar a partir de conceptos vistos en la cursada.
 
4 Punto C: Te pedí que no me lo dijeras
Pedimos que resuelvas el predicado leSpoileo/3 que relaciona a 2 personas y una serie si la primera le dijo a la segunda un spoiler para una serie que la segunda mira o planea ver.

Consejo: separar las responsabilidades en predicados más chicos.

Por ejemplo
Gastón le dijo a Maiu un spoiler de Game of Thrones (la relación de amistad entre Tyrion y el dragón)
Nico le dijo a Maiu un spoiler de Star Wars (la relación de parentesco entre Darth Vader y Luke Skywalker)

No se preocupen si en los resultados aparece más de una vez, esto es así por la naturaleza del motor de inferencia de Prolog.

¿Qué tipo de consultas (existenciales o individuales) pueden hacerse a la base de conocimientos? Justificar a partir de conceptos vistos en la cursada.

5 Punto D: Responsable
Resolver el predicado televidenteResponsable/1 que se cumple para una persona si no le spoileó ninguna serie a nadie. 

Por ejemplo:
Juan, Aye y Maiu son televidentes responsables
Nico y Gastón no son televidentes responsables

BONUS: Lograr que el predicado sea inversible.

6 Punto E: Viene Zafando
Resolver el predicado vieneZafando/2 que se cumple para alguien que mira o planea ver una serie y no se la spoilearon, a pesar de que la misma sea popular o que en todas sus temporadas hayan pasado cosas fuertes. Algo que pasó se considera fuerte si se trata de una muerte o de una relación amorosa o de parentesco.

Por ejemplo:
Maiu no viene zafando con ninguna serie.
Juan viene zafando tanto con “How I Met Your Mother”, “Game of Thrones” y “House of Cards”. No viene zafando con “Futurama”, porque no tenemos información sobre las temporadas que tiene (aunque sepamos que pasó algo fuerte, no nos alcanza).
Sólo Nico viene zafando con “Star Wars”.

7 Casos de prueba
Los casos de prueba están explicados en cada punto. Algunos docentes pueden tener sus casos de prueba implementados, en cuyo caso los adaptarán en el momento. En ese caso, para poder evaluar formalmente deberá dispararse la consulta
% run_tests.

según se indica en el apunte PlUnit para programadores prologueros

8 Conceptos a evaluar
Modelado de información
Principio de universo cerrado
Cuantificación universal (para todos)
Negación
Orden superior
Inversibilidad
Polimorfismo

#LógicoParte2

https://docs.google.com/document/d/1FEHfmBmZJvgLqUsCLQTLKmA50fGhznyct7o0s3YQRuE/edit?usp=sharing

<Spoiler Alert>


“¿Te dije que House of Cards no va más? Seguime a mí, pichón...”

Continuamos con el desarrollo de la aplicación de Spoilers en Prolog. Ahora nos han pedido nuevos requerimientos que describiremos a continuación.

1 Punto A: Malo, malo, malo eres...
Desarrollar el predicado malaGente/1 que se cumple para una persona si a todas las personas con las que habló les spoileó algo, o si a alguien le spoileó una serie que la mala persona ni siquiera mira.

Incorporemos a la base de conocimiento que Nico le dice a Juan acerca de la muerte de Seymour Diera en Futurama.
También sumemos a Pedro, que mira Game of Thrones.
Pedro le dijo a Aye que en la serie Game of Thrones hay una relación de amistad entre Tyrion y el dragón (que es cierta). Recordamos que Aye planea ver Game of Thrones. 
También le dijo a Nico que hay una relación de parentesco en Game of Thrones entre Tyrion y el dragón, cosa que no es cierta.

Gastón es mala gente, porque le spoileó a todas las personas a las que le habló (Maiu). 
Nico es mala gente, porque le spoileó a Juan la muerte de Seymour Diera en Futurama, serie que Nico ni siquiera mira.
Pedro no es mala gente, porque si bien le spoileó a Aye, le habló a Nico sin spoilearle.

2 Punto B: Series con cosas fuertes
Queremos agregar nuevas cosas que pasaron en la serie. Hasta el momento podía pasar que un personaje muera o que se devele una relación de una determinada naturaleza entre dos personas, ahora también queremos reflejar si ocurre un giro en la trama (plot twist), el cual se describe mediante una lista de palabras clave.

Debemos incorporar a la base los siguientes plot twists:
En Game of Thrones, temporada 3, capítulo 2, aparecen las palabras sueño (suenio) y “sin piernas” (sinPiernas)
En Game of Thrones, temporada 3, capítulo 12, aparecen las palabras fuego y boda
En Supercampeones, temporada 9, capítulo 9, aparecen las palabras sueño, coma y sin piernas
En Doctor House, temporada 8, capítulo 7, aparecen las palabras coma y pastillas

Se pide modificar el predicado que indica que algo es fuerte (de la entrega 1), donde sabemos que en toda serie una muerte y una relación de parentesco o amorosa es algo fuerte. 

En cuanto al giro o plot twist, es fuerte si no es cliché y pasó en un final de temporada. Consideramos que el giro es cliché si todas las palabras clave aparecen en giros de otras series (no necesariamente la misma serie para cada palabra).

Además, se pide tener un predicado que relacione a una serie con un suceso fuerte, independientemente de su temporada, para poder verificar lo siguiente:

la muerte de Seymour Diera en Futurama es algo fuerte
también la muerte de Emperor en Star Wars es algo fuerte
la relación de parentesco de Anakin y el Rey en Star Wars es algo fuerte
la relación de parentesco de Darth Vader y Luke en Star Wars es algo fuerte
la relación amorosa de Ted y Robin en How I met your mother es algo fuerte
la relación amorosa de Swarley y Robin en How I met your mother es algo fuerte
el plot twist que contiene las palabras fuego y boda en Game of Thrones (que no es cliché y pasó en un final de temporada) es algo fuerte
el plot twist que contiene la palabra sueño en Game of Thrones no es fuerte, porque es un cliché (“sueño” aparece por ejemplo en Super Campeones)
el plot twist que contiene las palabras coma y pastillas en Doctor House no es fuerte, ya que si bien no es cliché, no pasó en final de temporada

3 Punto C: Popularidad
¡¡Buenas noticias!! Se nos ocurrió una forma de generalizar cuándo una serie es popular. Modificar predicado popular/1 considerando que         se cumple para una serie si su popularidad, que es la cantidad de personas que la miran multiplicado por la cantidad de conversaciones de la misma, es mayor o igual que la conseguida por Star Wars, la cual consideramos como serie de referencia por su alta cantidad de fans en un grupo relativamente selecto. 

Game of Thrones y Star Wars (obviamente) son populares.
Además House of Cards es popular, independientemente de si se habla o no de ella. 

4 Punto D: Amigos son los amigos...
Agregamos a la base de conocimientos la relación de amistad entre dos personas: 

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

La relación amigo/2 es unidireccional de izquierda a derecha (el primero es amigo del segundo, no al revés) y cerrada (no tiene ciclos).

Resolver el predicado fullSpoil/2 que relaciona dos personas cuando el primero le dijo un spoil al segundo directamente o bien se lo dijo a un amigo del segundo, o al amigo de un amigo del segundo, o al amigo... en fin, creo que se entiende que la relación debe soportar n niveles de anidamiento. No es válido el auto-full-spoil.
    
Por ejemplo:

Nico hizo full spoil a Aye, Juan, Maiu y Gastón
Gastón hizo full spoil a Maiu, Juan y Aye
Maiu no hizo full spoil a nadie (no le dijo nada a nadie)

5 Casos de prueba
Se deberá desarrollar tests para cada punto solicitado, según lo indica el apunte PlUnit para programadores prologueros.

6 Conceptos a evaluar
Modelado de información
Principio de universo cerrado
Cuantificación universal (para todos)
Negación
Orden superior
Inversibilidad
Recursividad



