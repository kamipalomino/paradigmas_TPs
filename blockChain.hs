{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions -- Para mostrar <Function> en consola cada vez que devuelven una
import Data.List -- Para métodos de colecciones que no vienen por defecto (ver guía de lenguajes)
import Data.Maybe -- Por si llegan a usar un método de colección que devuelva “Just suElemento” o “Nothing”.
import Test.Hspec


------------TEST---------------------------------

-- EN LOS TEST SE ESTA COMPARANDO USUARIOS CON UN NUMERO ( AL MARGEN DE QUE EL ENUNCIADO PEDIA DEVOLVER BILLETERAS Y DEVUELVEN USUARIOS ) Y NO SE PUEDE COMPARAR DOS TIPOS DIFERENTES
-- TAMBIEN HAY MUCHOS PARENTESIS DE MAS, RELEER O REPASAR LA PRESEDENCIA DE LAS FUNCIONES EN HASKELL

usuarioCon10Monedas = Usuario "Pepe" 10


ejecutarTest = hspec $ do

  describe "Pruebas sobre los eventos" $ do

    it "Depositar 10 más. Debería quedar con 20 monedas." $ (billetera.deposita 10) usuarioCon10Monedas `shouldBe` 20
    it "Extraer 3: Debería quedar con 7" $ (billetera.extraccion 3) usuarioCon10Monedas `shouldBe` 7
    it "Extraer 15: Debería quedar con 0" $ (billetera.extraccion 15) usuarioCon10Monedas `shouldBe` 0
    it "Un upgrade: Debería quedar con 12." $  (billetera.upgrade) usuarioCon10Monedas `shouldBe` 12
    it "Cerrar la cuenta: 0." $  (billetera.cierraCuenta) usuarioCon10Monedas `shouldBe` 0
    it "Queda igual: 10." $ (billetera.quedaIgual) usuarioCon10Monedas  `shouldBe` 10
    it "Depositar 1000, y luego tener un upgrade: 1020." $ (billetera.upgrade.deposita 1000) usuarioCon10Monedas `shouldBe` 1020
    it "Toco y me voy, deberia quedar con 0." $ (billetera.tocoMeVoy) usuarioCon10Monedas `shouldBe` 0
    it "ahorrante errante, deberia quedar con 34." $ (billetera.ahorranteErrante) usuarioCon10Monedas`shouldBe` 34

  describe "Pruebas sobre los usuarios" $ do
    it "Cual es la billetera de Pepe?, deberia ser 10 monedas" $ (billetera.quedaIgual) pepe `shouldBe` 10
    it "Cual es la billetera de Pepe?, luego de un cierre de cuenta deberia ser 0 monedas" $ (billetera.cierraCuenta) pepe `shouldBe` 0
    it "Como queda la biletera de pepe si le epositan 15, se extrae 2 y tiene un upgrade, deberia ser 27,6" $  (billetera.upgrade.extraccion 2.deposita 15) pepe `shouldBe` 27.6

  describe "Pruebas sobre las transiciones" $ do

    it "Lucho toca y se va con billetera de 10 monedas, deberia quedar 0 monedas." $ (billetera.luchoTocaYSeVa lucho) usuarioCon10Monedas `shouldBe` 0
    it "Lucho es ahorrante errante con billetera de 10 monedas, deberia quedar 34 monedas." $ (billetera.luchoEsUnAhorranteErrante lucho) usuarioCon10Monedas `shouldBe` 34
    it "pepe le paga 7 monedas a lucho, deberia quedarle 3 monedas" $ (billetera.pepeLeDa7UnidadesALucho pepe) usuarioCon10Monedas `shouldBe` 3
    it "lucho recibe 7 monedas de pepe, deberia quedarle 17 monedas" $ (billetera.pepeLeDa7UnidadesALucho lucho) usuarioCon10Monedas `shouldBe` 17
    it "lucho cierra la cuenta aplicada a pepe, deberia quedar pepe sin cambios" $ (billetera.luchoCierraLaCuenta pepe) pepe `shouldBe` billetera pepe -- TODO Preguntar
    it "pepe le da 7 unidades a Lucho, deberia quedar lucho con 9 monedas" $  (billetera.pepeLeDa7UnidadesALucho lucho) lucho `shouldBe` 9
    it "pepe le da 7 unidades a Lucho y despues pepe deposita 5 monedas, deberia quedar con 8 monedas" $   (billetera.pepeLeDa7UnidadesALucho pepe.pepeDeposita5Monedas pepe) pepe `shouldBe` 8
    it "Impactar la transacción 1 a Pepe. Debería quedar igual que como está inicialmente."$ (billetera.usuarioLuegoDeTransaccion luchoCierraLaCuenta) pepe `shouldBe` 10
    it "Impactar la transacción 5 a Lucho. Debería producir que Lucho tenga 9 monedas en su billetera."$ (billetera.usuarioLuegoDeTransaccion pepeLeDa7UnidadesALucho) lucho `shouldBe` 9
    it "Impactar la transacción 5 y luego la 2 a Pepe. Eso hace que tenga 8 en su billetera."$ (billetera.usuarioLuegoDeTransaccion pepeDeposita5Monedas.usuarioLuegoDeTransaccion pepeLeDa7UnidadesALucho) pepe `shouldBe` 8

  describe "Pruebas sobre Bloques" $ do

--    it "Aplicar bloque1 a pepe. Debería quedar con su mismo nombre, pero con una billetera de 18." $ (billetera.aplicarBloque bloque1) pepe `shouldBe` 18
    -- it "Probar que para el bloque 1, y los usuarios Pepe y Lucho, el único que quedaría con un saldo mayor a 10, es Pepe." $ lleganANCreditos bloque1 10 usuarios `shouldBe` [pepe]

-----------TIPOS DE DATOS-----------------

-- NO SE ENTIENDE QUE FUNCION CUMPLE EL TYPE Transaccion SI ES IGUAL AL Evento Y DE TODAS MANERAS NO SE USA "Evento" EN EL CODIGO Y DEBERIA USARSE

type Evento = Usuario -> Usuario
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
quedaIgual :: Usuario -> Usuario
quedaIgual usuario = id usuario -- USAR LA FUNCION id TODO preguntar id
nuevaBilletera unMonto unUsuario = unUsuario {billetera = unMonto}
cierraCuenta usuario = nuevaBilletera 0 usuario
deposita unMonto usuario = nuevaBilletera ((billetera usuario) +  unMonto) usuario
tocoMeVoy usuario = (cierraCuenta.upgrade.deposita 15) usuario
ahorranteErrante usuario = (deposita 10 .upgrade .deposita 8 .extraccion 1 .deposita 2 .deposita 1) usuario

extraccion unMonto usuario
  | (billetera usuario) - unMonto < 0 = cierraCuenta usuario
  | otherwise = nuevaBilletera ((billetera usuario) - unMonto) usuario

minCantidadMonedasUpgrade usuario = (billetera usuario + (min (billetera usuario * 1.2 - billetera usuario) 10))
upgrade usuario = nuevaBilletera (minCantidadMonedasUpgrade usuario) usuario


------------------TRANSACCIONES------------------

aplicarEvento usuarioAAplicar usuarioAVerificar evento
  | compararUsuarios usuarioAAplicar usuarioAVerificar = evento
  | otherwise = quedaIgual

luchoCierraLaCuenta :: Transaccion
luchoCierraLaCuenta usuarioAVerificar = aplicarEvento lucho usuarioAVerificar cierraCuenta

pepeDeposita5Monedas :: Transaccion
pepeDeposita5Monedas usuarioAVerificar =  aplicarEvento pepe usuarioAVerificar (deposita 5)

luchoTocaYSeVa :: Transaccion
luchoTocaYSeVa usuarioAVerificar =  aplicarEvento lucho usuarioAVerificar tocoMeVoy

luchoEsUnAhorranteErrante :: Transaccion
luchoEsUnAhorranteErrante usuarioAVerificar = aplicarEvento lucho usuarioAVerificar ahorranteErrante


-----------------------PAGOS----------------------

usuarioPagaAOtroUsuario :: Pago
usuarioPagaAOtroUsuario usuarioQuePaga usuarioQueCobra cantidad unUsuario
  | compararUsuarios usuarioQuePaga unUsuario   = extraccion cantidad
  | compararUsuarios usuarioQueCobra unUsuario = deposita cantidad
  | otherwise = quedaIgual

pepeLeDa7UnidadesALucho :: Transaccion
pepeLeDa7UnidadesALucho = usuarioPagaAOtroUsuario pepe lucho 7     --TODO preguntar pagos

-------------FUNCIONES AUXILIARES-----------------

compararUsuarios usuario1 usuario2 = nombre usuario1 == nombre usuario2
saldoAlMenosNMonedas n  = (<)n. billetera

-----------------------BLOQUES/BLOCKCHAINS----------------------------------

type Bloque = [Transaccion]
type BlockChain = [Bloque]


usuarioLuegoDeTransaccion unaTransicion unUsuario = unaTransicion unUsuario unUsuario
bloque1 = [luchoCierraLaCuenta,pepeDeposita5Monedas,pepeDeposita5Monedas,pepeDeposita5Monedas,luchoTocaYSeVa,luchoEsUnAhorranteErrante,pepeLeDa7UnidadesALucho,luchoTocaYSeVa];
usuarios = [pepe,lucho]
--bloque2 = [pepeDeposita5Monedas,pepeDeposita5Monedas,pepeDeposita5Monedas,pepeDeposita5Monedas,pepeDeposita5Monedas];
--blockchain1 = [bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1,bloque2,bloque1]

-- (f: fs) lista de funciones -- bloque
-- (u:us) lista de usuarios
-- (b:bs) lista de bloques --blockchain

--aplicarTransaccionaBloque = map usuarioLuegoDeTransaccion bloque1

componerBloque [] = id
componerBloque (f: fs) = (.) (usuarioLuegoDeTransaccion f) (componerBloque fs)
--componerBloque (f) = foldr ((.)) id (f)

aplicarBloque (f:fs) unUsuario =  componerBloque (f:fs) unUsuario

aplicarBloqueAMuchos (f:fs) = map(componerBloque (f:fs))

--lleganANCreditos (f:fs) unMonto = filter (saldoAlMenosNMonedas unMonto).aplicarBloqueAMuchos bloque1
-- compararUsuarios (f:fs) (u:us) = como itero la lista que me devuelve  aplicarBloqueAMuchos (f:fs) (u:us) ?????  igual esta funcion no haria falta
-- elMasPobre (f:fs) (u:us) = foldl min map (billetera) aplicarBloqueAMuchos (f:fs) (u:us) asi estara bien??
-- esRickyFort (f:fs) (u:us) = foldl max map (billetera) aplicarBloqueAMuchos (f:fs) (u:us) asi estara bien??

-- como iterar dentro cada bloque dentro del blockchain???????? sera b:bs:bss???  tanto b como bs son listas
--componerBlockChain (b:bs) =
--aplicarBlockChain (b:bs) unUsuario = (aplicarBloque bs .aplicarBloque b) unUsuario  --aplico bloque cabeza y luego compongo con los de la cola
--aplicarBlockChainAMuchos (b:bs) (u:us) = map (aplicarBlockChain (b:bs)) (u:us)
-- ver como componer solo cierta cantidad de aplicarBloque en aplicarBlockChain para saber como esta el usuario luego de transitar N bloques

-- el blockchain infinito debe devolver un blockchain a partir de un tipo de bloque -- Bloque -> Usuario -> BlockChain
--Cada bloque deberá contener todas las transacciones del anterior, dos veces. a que mierda se refiere ???????'
--BlockChainInfinito (f: fs) unUsuario unMonto =
