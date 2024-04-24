import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}

-- Primera Parte

-- Punto 1

type Gema = Personaje -> Personaje
type Habilidad = String

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
} deriving (Show)

data Personaje = Personaje {
    edad :: Int,
    energia :: Int,
    habilidades :: [Habilidad],
    nombre :: String,
    planeta :: String
} deriving (Show,Eq)

type Universo = [Personaje]

ironMan = Personaje{
    edad = 50,
    energia = 20,
    habilidades = ["Volar"],
    nombre = "Tonik",
    planeta = "Tierra"
}
capAmerica = Personaje{
    edad = 65,
    energia = 33,
    habilidades = ["Luchar","Agilidad"],
    nombre = "Steve",
    planeta = "Tierra"
}


chasquido :: Guantelete -> Universo -> Universo
chasquido guantelete universo 
    | (length (gemas guantelete) == 6) && (material guantelete == "uru") = take (div (length universo) 2) universo
    | otherwise = universo


-- Punto 2

universoAptoPandex :: Universo -> Bool
universoAptoPandex universo = any (algunoMenor45) universo

algunoMenor45 personaje = (edad personaje) < 45

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso universo = (sum . (map energia) . (filter (masHabilidades)) ) universo

masHabilidades personaje = (length (habilidades personaje)) > 1


-- Segunda Parte

-- Punto 3

mente :: Int -> Gema
mente valor personaje  = disminuirEnergia valor personaje 

disminuirEnergia valor personaje  = personaje {energia = (energia personaje) -  valor}

alma :: String -> Gema
alma habilidad personaje  = disminuirEnergia 10 personaje {habilidades = filter (/= habilidad)  (habilidades personaje)}

espacio :: String -> Gema
espacio planetaDeseado personaje = disminuirEnergia 20 personaje {planeta = planetaDeseado}

poder:: Gema
poder personaje = ( quitarHabilidades . disminuirEnergia (energia personaje) ) personaje

quitarHabilidades personaje
    | (length (habilidades personaje)) <=2 = personaje {habilidades = []}
    | otherwise = personaje


tiempo :: Gema
tiempo personaje = disminuirEnergia 50 personaje {edad = max (div (edad personaje) 2) 18}

gemaLoca :: Gema -> Gema
gemaLoca gema = gema.gema

-- Punto 4

guantelete1 = Guantelete {
    material = "Goma",
    gemas = [tiempo,alma "usar Mjolnir",gemaLoca (alma "programacion Haskell")]
}

-- Punto 5

utilizar listaGemas enemigo = foldl (usarGema) enemigo listaGemas

usarGema enemigo gema = gema enemigo

-- Punto 6

gemaMasPoderosa personaje guantelte = gemaMasPoderosaDe personaje $ gemas guantelte

gemaMasPoderosaDe personaje (gema1:gema2:gemas) 
    | (energia.gema1) personaje < (energia.gema2) personaje = gemaMasPoderosaDe personaje (gema1:gemas)
    | otherwise = gemaMasPoderosaDe personaje (gema2:gemas)

-- Punto 7 

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

-- gemaMasPoderosa ironMan guanteleteDeLocos
-- usoLasTresPrimerasGemas guanteleteDeLocos ironMan

{-
    La funcion gemaMasPoderosa no se va a poder ejecutar, ya que nunca va a poder dejar de comparar entre las gemas para
    saber cual es la mejor, ya que son infinitas. En este caso, como el resultado no es posible, el algoritmo diverge

    La funcion usoLasTresPrimerasGemas siempre se va a poder ejecutar aunque el guantelete lleve infinitas gemas, esto
    se debe a que haskell utiliza el termino de "Evaluacion Diferida", en el cual va utilizando lo que le dan a medida
    que lo necesita. En este caso, no calcula primero la lista infinita de gemas, sino que va generando hasta obtener
    las 3 primeras gemas de la lista y las utiliza, y no le importa cuantas ni cuales habian en la lista despues de 
    esas 3. Por lo que, puede converger a un cierto valor

-}
