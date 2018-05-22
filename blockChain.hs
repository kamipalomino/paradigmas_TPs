{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions -- Para mostrar <Function> en consola cada vez que devuelven una
import Data.List -- Para métodos de colecciones que no vienen por defecto (ver guía de lenguajes)
import Data.Maybe -- Por si llegan a usar un método de colección que devuelva “Just suElemento” o “Nothing”.
import Test.Hspec


------------TEST---------------------------------

-- EN LOS TEST SE ESTA COMPARANDO USUARIOS CON UN NUMERO ( AL MARGEN DE QUE EL ENUNCIADO PEDIA DEVOLVER BILLETERAS Y DEVUELVEN USUARIOS ) Y NO SE PUEDE COMPARAR DOS TIPOS DIFERENTES
-- TAMBIEN HAY MUCHOS PARENTESIS DE MAS, RELEER O REPASAR LA PRESEDENCIA DE LAS FUNCIONES EN HASKELL

billeteraDeUsuarioCon10Monedas = billetera (Usuario "pepe" 10)


ejecutarTest = hspec $ do

  describe "Pruebas sobre los eventos" $ do
    it "Depositar 10 más. Debería quedar con 20 monedas." $ deposita 10 billeteraDeUsuarioCon10Monedas `shouldBe` 20
    it "Extraer 3: Debería quedar con 7" $ extraccion 3 billeteraDeUsuarioCon10Monedas `shouldBe` 7
    it "Extraer 15: Debería quedar con 0" $ extraccion 15 billeteraDeUsuarioCon10Monedas `shouldBe` 0
    it "Un upgrade: Debería quedar con 12." $  upgrade billeteraDeUsuarioCon10Monedas `shouldBe` 12
    it "Cerrar la cuenta: 0." $  cierraCuenta billeteraDeUsuarioCon10Monedas `shouldBe` 0
    it "Queda igual: 10." $ quedaIgual billeteraDeUsuarioCon10Monedas  `shouldBe` 10
    it "Depositar 1000, y luego tener un upgrade: 1020." $ (upgrade.deposita 1000) billeteraDeUsuarioCon10Monedas `shouldBe` 1020
    it "Toco y me voy, deberia quedar con 0." $ tocoMeVoy billeteraDeUsuarioCon10Monedas `shouldBe` 0
    it "ahorrante errante, deberia quedar con 34." $ ahorranteErrante billeteraDeUsuarioCon10Monedas`shouldBe` 34

  describe "Pruebas sobre los usuarios" $ do
    it "Cual es la billetera de Pepe?, deberia ser 10 monedas" $ (quedaIgual.billetera) pepe `shouldBe` 10
    it "Cual es la billetera de Pepe?, luego de un cierre de cuenta deberia ser 0 monedas" $ (cierraCuenta. billetera) pepe `shouldBe` 0
    it "Como queda la biletera de pepe si le epositan 15, se extrae 2 y tiene un upgrade, deberia ser 27,6" $  (upgrade.extraccion 2.deposita 15.billetera) pepe `shouldBe` 27.6

  describe "Pruebas sobre las transiciones" $ do
    it "Lucho toca y se va con billetera de 10 monedas, deberia quedar 0 monedas." $ luchoTocaYSeVa lucho billeteraDeUsuarioCon10Monedas `shouldBe` 0
    --it "Lucho es ahorrante errante con billetera de 10 monedas, deberia quedar 34 monedas." $ luchoEsUnAhorranteErrante lucho billeteraDeUsuarioCon10Monedas `shouldBe` 34
    it "pepe le paga 7 monedas a lucho, deberia quedarle 3 monedas" $ pepeLeDa7UnidadesALucho pepe billeteraDeUsuarioCon10Monedas `shouldBe` 3
    it "lucho recibe 7 monedas de pepe, deberia quedarle 17 monedas" $ pepeLeDa7UnidadesALucho lucho billeteraDeUsuarioCon10Monedas `shouldBe` 17
    it "lucho cierra la cuenta aplicada a pepe, deberia quedar pepe sin cambios" $ (luchoCierraLaCuenta pepe. billetera) pepe `shouldBe` billetera pepe -- TODO Preguntar
    it "pepe le da 7 unidades a Lucho, deberia quedar lucho con 9 monedas" $  (pepeLeDa7UnidadesALucho lucho. billetera) lucho `shouldBe` 9
    it "pepe le da 7 unidades a Lucho y despues pepe deposita 5 monedas, deberia quedar con 8 monedas" $   (pepeLeDa7UnidadesALucho pepe.pepeDeposita5Monedas pepe. billetera) pepe `shouldBe` 8
    it "Impactar la transacción 1 a Pepe. Debería quedar igual que como está inicialmente." $ (luchoCierraLaCuenta pepe.billetera) pepe `shouldBe` 10
    it "Impactar la transacción 5 a Lucho. Debería producir que Lucho tenga 9 monedas en su billetera." $ (pepeLeDa7UnidadesALucho lucho.billetera) lucho `shouldBe` 9
    it "Impactar la transacción 5 y luego la 2 a Pepe. Eso hace que tenga 8 en su billetera." $ (pepeDeposita5Monedas pepe. pepeLeDa7UnidadesALucho pepe. billetera) pepe `shouldBe` 8
-- --it "Impactar la transaccion 2 a Pepe, deberia quedar con 15" $ pepeDeposita5Monedas pepe `shouldBe` 15
  -- describe "Pruebas sobre Bloques" $ do
    -- it "Aplicar bloque1 a pepe. Debería quedar con su mismo nombre, pero con una billetera de 18." $ (billetera.aplicarBloque bloque1) pepe `shouldBe` 18
    -- it "Para el bloque 1, y los usuarios Pepe y Lucho, el único que quedaría con un saldo mayor a 10, es Pepe." $ usuarioQueLleganANCreditos bloque1 10 usuarios `shouldBe` [pepe]
    -- it "Para el bloque 1, y los usuarios Pepe y Lucho, quien es el mas adinerado, quedaria Pepe." $  elUsuarioMasRickyFord bloque1 usuarios `shouldBe` pepe
    -- it "Para el bloque 1, y los usuarios Pepe y Lucho, quien es el mas pobre, quedaria Pepe." $  elUsuarioMasPobre bloque1 usuarios `shouldBe` lucho

 -- describe "Pruebas de BlockChain" $ do
   -- it "Aplicar blockchain a pepe. Deberia quedar su billetera con 115 monedas" $ aplicarBlockChain blockchain pepe `shouldBe` billetera pepe 115
    --it "transitar primeros 3 bloques. Pepe deberia quedar con 51 monedas" $ saldoDespuesDeN 3 blockchain pepe `shouldBe` billetera pepe 51
    --it "Aplicar blockchain a listadeusuarios. La suma total de sus billeteras deberia ser 115 monedas" $ ((sum)billetera pepe billetera lucho .(aplicarBlockChainAMuchos blockchain listadeusuarios)) `shouldBe` 115
    -------------TIPOS DE DATOS-----------------

-- NO SE ENTIENDE QUE FUNCION CUMPLE EL TYPE Transaccion SI ES IGUAL AL Evento Y DE TODAS MANERAS NO SE USA "Evento" EN EL CODIGO Y DEBERIA USARSE

type Evento = Monedas -> Monedas
type Transaccion = Usuario -> Evento
type Pago = Usuario -> Usuario -> Monedas -> Usuario -> Evento
type Monedas = Float
type Nombre = String
type Nivel = Int

data Usuario = Usuario {
  nombre :: Nombre,
  billetera :: Monedas
} deriving (Show,Eq)

--------------USUARIOS-------------------

pepe = Usuario "Jose" 10
lucho = Usuario "luciano" 2



-----------EVENTOS-------------------------
-- TIENEN QUE DELEGAR MAS EN LA FUNCION extraccion Y NO!! USEN GUARDA CUANDO DELEGUEN LA FUNCION (VIMOS UN EJEMPLO PARECIDO EN LAS PRIMERAS CLASES )

nuevaBilletera unMonto unUsuario = unUsuario {billetera = unMonto}

quedaIgual::Evento
cierraCuenta:: Evento
upgrade :: Evento
deposita:: Monedas -> Evento
extraccion:: Monedas -> Evento
tocoMeVoy:: Evento
ahorranteErrante ::Evento

quedaIgual cantBilletera = id cantBilletera  -- USAR LA FUNCION id TODO preguntar id
cierraCuenta _ = 0
deposita unMonto  = (+) unMonto

tocoMeVoy = cierraCuenta.upgrade.deposita 15 --TODO seguro esta mal esto
ahorranteErrante cantBilletera =  (deposita 10 .upgrade .deposita 8 .extraccion 1 .deposita 2 .deposita 1) cantBilletera


extraccion unMonto = max 0. (+) (-unMonto)

minCantidadMonedasUpgrade cantBilletera = (min (cantBilletera * 1.2 - cantBilletera) 10)
upgrade cantBilletera = (minCantidadMonedasUpgrade cantBilletera) + cantBilletera


------------------TRANSACCIONES------------------
generarTransaccionAUnUsuario::Evento->Usuario->Usuario->Evento
generarTransaccionAUnUsuario evento usuarioAAplicar usuarioAVerificar
  | compararUsuariosPorPorNombre usuarioAAplicar usuarioAVerificar = evento
  | otherwise = quedaIgual

luchoCierraLaCuenta :: Transaccion
luchoCierraLaCuenta = generarTransaccionAUnUsuario cierraCuenta lucho

pepeDeposita5Monedas :: Transaccion
pepeDeposita5Monedas  =  generarTransaccionAUnUsuario (deposita 5) pepe

luchoTocaYSeVa :: Transaccion
luchoTocaYSeVa  =  generarTransaccionAUnUsuario tocoMeVoy lucho

luchoEsUnAhorranteErrante :: Transaccion
luchoEsUnAhorranteErrante = generarTransaccionAUnUsuario ahorranteErrante lucho


-----------------------PAGOS----------------------

usuarioPagaAOtroUsuario :: Pago
usuarioPagaAOtroUsuario usuarioQuePaga usuarioQueCobra cantidad unUsuario
  | compararUsuariosPorPorNombre usuarioQuePaga unUsuario   = extraccion cantidad
  | compararUsuariosPorPorNombre usuarioQueCobra unUsuario = deposita cantidad
  | otherwise = quedaIgual

pepeLeDa7UnidadesALucho :: Transaccion
pepeLeDa7UnidadesALucho = usuarioPagaAOtroUsuario pepe lucho 7     --TODO preguntar pagos

-------------FUNCIONES AUXILIARES-----------------

compararUsuariosPorPorNombre usuario1 usuario2 = nombre usuario1 == nombre usuario2
saldoAlMenosNMonedas n  = (<)n. billetera

deAlgoTomarN :: a -> Int ->[a]
deAlgoTomarN algo numero = (take numero. repeat) algo
deAlgoCortarN algo numero = drop numero algo

comparar criterio algo primero siguiente
  | (criterio) (algo primero) (algo siguiente) == algo primero = primero
  | otherwise = siguiente
--mejorSegun criterio (primero:siguiente) = foldr (comparar criterio) primero siguiente
--aplicarTodo = foldr​ (.) id
--aplicarTodo2 = foldl​ (flip​ (.)) id
--afectarCon bloque unUsuario = ​foldl​ (​flip​ ($)) unUsuario bloque
------------------------------BLOQUES/BLOCKCHAINS---------------------------------
type Bloque = [Transaccion]
type BlockChain = [Bloque]
listadeusuarios :: [Usuario]
listadeusuarios = [pepe,lucho]

bloque1 = [luchoCierraLaCuenta,pepeDeposita5Monedas,pepeDeposita5Monedas,pepeDeposita5Monedas,luchoTocaYSeVa,luchoEsUnAhorranteErrante,pepeLeDa7UnidadesALucho,luchoTocaYSeVa];
bloque2 = deAlgoTomarN pepeDeposita5Monedas 5
blockchain = [bloque2] ++ (deAlgoTomarN bloque1 10)
blockchain2 = unaBlockchainInfinita bloque1

usuarioLuegoDeTransaccion unaTransicion unUsuario = unaTransicion unUsuario unUsuario

aplicarTransaccionAUsuario :: Transaccion -> Usuario -> Usuario
aplicarTransaccionAUsuario transaccion unUsuario = nuevaBilletera (transaccion unUsuario (billetera unUsuario)) unUsuario


aplicarBloque bloque unUsuario = foldr aplicarTransaccionAUsuario unUsuario bloque
aplicarBloqueAMuchos bloque lista = map (aplicarBloque bloque1) lista

usuarioCompararSaldo criterio unUsuario otroUsuario
  | (criterio) (billetera unUsuario) (billetera otroUsuario) == billetera unUsuario = unUsuario
  | otherwise = otroUsuario

mejorSegunSaldo criterio (primerUsuario:restoUsuarios) = foldr (usuarioCompararSaldo criterio) primerUsuario restoUsuarios

mejorSegunBilletera [usuario] = usuario
mejorSegunBilletera (primerUsuario:otroUsuario:restoUsuarios)
    | (>)(billetera primerUsuario) (billetera otroUsuario) = mejorSegunBilletera (primerUsuario:restoUsuarios)
    | otherwise = mejorSegunBilletera (otroUsuario:restoUsuarios)

encontrarMejorUsuarioSegun criterio bloque lista = find (compararUsuariosPorPorNombre (mejorSegunSaldo criterio (aplicarBloqueAMuchos bloque lista))) lista
elUsuarioMasRickyFord bloque  = encontrarMejorUsuarioSegun max bloque
elUsuarioMasPobre bloque  = encontrarMejorUsuarioSegun min bloque

lleganANCreditos bloque unMonto = filter (saldoAlMenosNMonedas unMonto.aplicarBloque bloque)
blockchainInfinita unbloque =  unbloque: (blockchainInfinita unbloque)

unaBlockchainInfinita (primerBloque:_) _ = []
unaBlockchainInfinita (_:otroBloque) bloque = otroBloque: ((take 2 . blockchainInfinita) bloque)


aplicarBlockChain :: BlockChain -> Usuario -> Usuario

aplicarBlockChain unaBlockchain unUsuario = foldr aplicarBloque unUsuario unaBlockchain
aplicarBlockChainAMuchos unaBlockchain lista = map (aplicarBlockChain unaBlockchain) lista
aplicarBlockChainInfinita unaBlockchainInfinita unUsuario = foldr aplicarBlockChain unUsuario unaBlockchainInfinita

saldoDespuesDeN numero unaBlockchain unUsuario= aplicarBlockChain (take numero unaBlockchain) unUsuario
peorBloque (primerBloque:otroBloque) unUsuario = foldr (comparar min (billetera.aflip aplicarBloque unUsuario)) primerBloque otroBloque

aflip funcion arg1 arg2 = funcion arg2 arg1 
-- como iterar dentro cada bloque dentro del blockchain???????? sera b:bs:bss???  tanto b como bs son listas
--componerBlockChain (b:bs) =
--aplicarBlockChain (b:bs) unUsuario = (aplicarBloque bs .aplicarBloque b) unUsuario  --aplico bloque cabeza y luego compongo con los de la cola
--aplicarBlockChainAMuchos (b:bs) (u:us) = map (aplicarBlockChain (b:bs)) (u:us)
-- ver como componer solo cierta cantidad de aplicarBloque en aplicarBlockChain para saber como esta el usuario luego de transitar N bloques

-- el blockchain infinito debe devolver un blockchain a partir de un tipo de bloque -- Bloque -> Usuario -> BlockChain
--Cada bloque deberá contener todas las transacciones del anterior, dos veces. a que mierda se refiere ???????'
--BlockChainInfinito (f: fs) unUsuario unMonto =
