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
    it "Lucho es ahorrante errante con billetera de 10 monedas, deberia quedar 34 monedas." $ luchoEsUnAhorranteErrante lucho billeteraDeUsuarioCon10Monedas `shouldBe` 34
    it "pepe le paga 7 monedas a lucho, deberia quedarle 3 monedas" $ pepeLeDa7UnidadesALucho pepe billeteraDeUsuarioCon10Monedas `shouldBe` 3
    it "lucho recibe 7 monedas de pepe, deberia quedarle 17 monedas" $ pepeLeDa7UnidadesALucho lucho billeteraDeUsuarioCon10Monedas `shouldBe` 17
    it "lucho cierra la cuenta aplicada a pepe, deberia quedar pepe sin cambios" $ (luchoCierraLaCuenta pepe. billetera) pepe `shouldBe` billetera pepe -- TODO Preguntar
    it "pepe le da 7 unidades a Lucho, deberia quedar lucho con 9 monedas" $  (pepeLeDa7UnidadesALucho lucho. billetera) lucho `shouldBe` 9
    it "pepe le da 7 unidades a Lucho y despues pepe deposita 5 monedas, deberia quedar con 8 monedas" $   (pepeLeDa7UnidadesALucho pepe.pepeDeposita5Monedas pepe. billetera) pepe `shouldBe` 8
    it "Impactar la transacción 1 a Pepe. Debería quedar igual que como está inicialmente." $ (luchoCierraLaCuenta pepe.billetera) pepe `shouldBe` 10
    it "Impactar la transacción 5 a Lucho. Debería producir que Lucho tenga 9 monedas en su billetera." $ (pepeLeDa7UnidadesALucho lucho.billetera) lucho `shouldBe` 9
    it "Impactar la transacción 5 y luego la 2 a Pepe. Eso hace que tenga 8 en su billetera." $ (pepeDeposita5Monedas pepe. pepeLeDa7UnidadesALucho pepe. billetera) pepe `shouldBe` 8

  describe "Pruebas sobre Bloques" $ do

    it "Aplicar bloque1 a pepe. Debería quedar con su mismo nombre, pero con una billetera de 18." $ (billetera.aplicarBloque bloque1) pepe `shouldBe` 18
    it "Para el bloque 1, y los usuarios Pepe y Lucho, el único que quedaría con un saldo mayor a 10, es Pepe." $ usuariosQueLleganANCreditos bloque1 10 usuarios `shouldBe` [pepe]
    it "Para el bloque 1, y los usuarios Pepe y Lucho, quien es el mas adinerado, quedaria Pepe." $  elUsuarioMasRickyFord bloque1 usuarios `shouldBe` pepe
    it "Para el bloque 1, y los usuarios Pepe y Lucho, quien es el mas pobre, quedaria Pepe." $  elUsuarioMasPobre bloque1 usuarios `shouldBe` lucho

  describe "Pruebas sobre BlockChain" $ do

    it "buscar el peor bloque para pepe en la blockChain, deberia encontrar bloque1" $ (billetera.flip aplicarBloque pepe.peorBloqueParaUnUsuario blockchain1) pepe  `shouldBe` 18
    it "aplicar blockchain1 a pepe, deberia quedar con 115 monedas" $ (billetera.aplicarBlockChain blockchain1) pepe `shouldBe` 115
    it "aplicar primeros 3 bloques de la blockChain a pepe, deberia quedar 51 monedas" $ (billetera.aplicarPrimerosNBloquesAUsuario 3 blockchain1) pepe `shouldBe` 51
    it "aplicar blockChain a pepe y lucho, deben quedar con 115 y 0 monedas." $  foldr (+) 0 (map billetera (aplicarBlockChainAMuchos blockchain1 usuarios)) `shouldBe` 115
    it "buscar cantidad necesaria para que pepe llegue a 10000 monedas, serian 11 bloques" $ (length.bloquesParaLLegarNMonedas 10000 blockchainInfinito) pepe `shouldBe` 11

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
quedaIgual  = id   -- USAR LA FUNCION id TODO preguntar id

cierraCuenta:: Evento
cierraCuenta _ = 0

deposita:: Monedas -> Evento
deposita  = (+)

tocoMeVoy:: Evento
tocoMeVoy = cierraCuenta.upgrade.deposita 15 --TODO seguro esta mal esto

ahorranteErrante ::Evento
ahorranteErrante cantBilletera =  (deposita 10 .upgrade .deposita 8 .extraccion 1 .deposita 2 .deposita 1) cantBilletera

extraccion:: Monedas -> Evento
extraccion unMonto = max 0. (+) (-unMonto)

upgrade :: Evento
upgrade cantBilletera = (minCantidadMonedasUpgrade cantBilletera) + cantBilletera
minCantidadMonedasUpgrade cantBilletera = (min (cantBilletera * 1.2 - cantBilletera) 10)

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

compararSegun criterio funcion unElemento otroElemento
  | (criterio) (funcion unElemento) (funcion otroElemento) == funcion unElemento = unElemento
  | otherwise = otroElemento

------------------------------BLOQUES/BLOCKCHAINS---------------------------------
type Bloque = [Transaccion]
type BlockChain = [Bloque]
usuarios :: [Usuario]
usuarios = [pepe,lucho]

bloque1 = [luchoCierraLaCuenta,pepeDeposita5Monedas,pepeDeposita5Monedas,pepeDeposita5Monedas,luchoTocaYSeVa,luchoEsUnAhorranteErrante,pepeLeDa7UnidadesALucho,luchoTocaYSeVa];
bloque2 = deAlgoTomarN pepeDeposita5Monedas 5
blockchain1 = [bloque2] ++ (deAlgoTomarN bloque1 10)
blockchainInfinito = generarBlockchainInfinito bloque1

usuarioLuegoDeTransaccion unaTransicion unUsuario = unaTransicion unUsuario unUsuario

aplicarTransaccionAUsuario :: Transaccion -> Usuario -> Usuario
aplicarTransaccionAUsuario transaccion unUsuario = nuevaBilletera (transaccion unUsuario (billetera unUsuario)) unUsuario


aplicarBloque bloque unUsuario = foldr aplicarTransaccionAUsuario unUsuario bloque
aplicarBloqueAMuchos bloque  = map (aplicarBloque bloque)

usuarioCompararSaldo criterio unUsuario otroUsuario
  | (criterio) (billetera unUsuario) (billetera otroUsuario) == billetera unUsuario = unUsuario
  | otherwise = otroUsuario

mejorSegunSaldo criterio (primerUsuario:restoUsuarios) = foldr (usuarioCompararSaldo criterio) primerUsuario restoUsuarios


encontrarMejorUsuarioSegun criterio bloque lista =fromJust( find (compararUsuariosPorPorNombre (mejorSegunSaldo criterio (aplicarBloqueAMuchos bloque lista))) lista )
elUsuarioMasRickyFord bloque  = encontrarMejorUsuarioSegun max bloque
elUsuarioMasPobre bloque  = encontrarMejorUsuarioSegun min bloque

usuariosQueLleganANCreditos bloque unMonto = filter (saldoAlMenosNMonedas unMonto.aplicarBloque bloque)

generarBlockchainInfinito bloque = bloque : (generarBlockchainInfinito (bloque ++ bloque))

aplicarBlockChain :: BlockChain -> Usuario -> Usuario

aplicarBlockChain unaBlockchain unUsuario = foldr aplicarBloque unUsuario unaBlockchain
aplicarBlockChainAMuchos unaBlockchain = map (aplicarBlockChain unaBlockchain)
--aplicarBlockChainInfinita unaBlockchainInfinita unUsuario = foldr aplicarBlockChain unUsuario unaBlockchainInfinita

peorBloqueParaUnUsuario (primerBloque:restoBloque) unUsuario = foldr (compararSegun min (billetera.flip aplicarBloque unUsuario)) primerBloque restoBloque

aplicarPrimerosNBloquesAUsuario n blockChain = aplicarBlockChain (take n blockChain)

cantBloquesParaLlegarNMonedas saldo (bloque:restoBloques) = (length.bloquesParaLLegarNMonedas saldo (bloque:restoBloques))

--bloquesParaLlegarNSaldo :: Monedas -> [Bloque] -> Usuario -> [Transaccion]
bloquesParaLLegarNMonedas saldo (bloque:restoBloques) unUsuario
  | billetera unUsuario < saldo = bloque : bloquesParaLLegarNMonedas saldo restoBloques (aplicarBloque bloque unUsuario)
  | otherwise = []

{-
Para la función bloquesParaLLegarNMonedas se utilizo evaluación diferida,
así va generando la blockchain infinita a medida que la va usando.
-}
