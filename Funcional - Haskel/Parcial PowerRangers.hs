import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}

-- Punto 1

type Habilidad = String

data Persona = Persona {
    habilidades :: [Habilidad],
    esBuena :: Bool
} deriving (Show)

data PowerRanger = PowerRanger{
    color :: String,
    habilidades1 :: [Habilidad],
    nivelPelea :: Int
} deriving (Show)


leandro = Persona{
    habilidades = ["Leer","Saltar"],
    esBuena = True
}

mariana = Persona{
    habilidades = ["Gritar","Pelear","Pensar"],
    esBuena = False
}

raul = PowerRanger{
    color = "Rojo",
    habilidades1 = ["Pelear"],
    nivelPelea = 200
}

maxi = PowerRanger{
    color = "Negro",
    habilidades1 = ["Pelear"],
    nivelPelea = 50
}

pedro = PowerRanger{
    color = "Azul",
    habilidades1 = ["Pelear"],
    nivelPelea = 70
}

-- Punto 2

convertirEnPowerRanger :: String -> Persona -> PowerRanger
convertirEnPowerRanger color persona = PowerRanger {
    color = color,
    habilidades1 = map (superHabilidades) (habilidades persona),
    nivelPelea = (sum . map (length)) (habilidades persona)
}

superHabilidades habilidad = "super" ++ habilidad


-- Punto 3

formarEquipoRanger :: [String] -> [Persona] -> [PowerRanger]
formarEquipoRanger listaColores listaPersonas = 
    zipWith convertirEnPowerRanger listaColores (filter esBuena listaPersonas)

-- Punto 4

-- a

findOrElse :: (a -> Bool) -> a -> [a] -> a
findOrElse condicion valor lista
    | length (filter condicion lista) > 0 = head (filter condicion lista)
    | otherwise = valor

-- b

rangerLider :: [PowerRanger] -> PowerRanger
rangerLider equipoRanger = findOrElse (esColorRojo) (head equipoRanger) equipoRanger

esColorRojo powerRanger = (color powerRanger) == "Rojo"

-- Punto 5

-- a

maxiumBy :: (Foldable t1, Ord a) => t1 t2 -> (t2 -> a) -> t2
maxiumBy lista funcion = foldl1 (\ elem1 elem2 -> maximo funcion elem1 elem2) lista
 where maximo funcion a b | funcion a > funcion b = a
                          |otherwise = b
   
-- b

rangerMasPoderoso :: [PowerRanger] -> PowerRanger
rangerMasPoderoso grupoRangers = maxiumBy grupoRangers nivelPelea

-- Punto 6

rangerHabilidoso :: PowerRanger -> Bool
rangerHabilidoso powerRanger = length (habilidades1 powerRanger) > 5

-- Punto 7 

-- a

alfa5 = PowerRanger{
    color = "Metalico",
    habilidades1 = ["Reparar","Decir " ++ ay],
    nivelPelea = 0
}

ay = "ay" ++ " " ++ ay

-- b

{- ejemplo de funcion que converga: rangerHabilidoso

   ejemplo de funcion que diverga: rangerLider, en el caso de que estuviese primero, lo muestra pero nunca termina de
   mostrar sus habilidades
-}

-- Punto 8

data ChicaSuperpoderosa = ChicaSuperpoderosa{
    color1 :: String,
    cantPelo :: Int
} deriving (Show)

bombon = ChicaSuperpoderosa{
    color1 = "Rojo",
    cantPelo = 20
}

burbuja = ChicaSuperpoderosa{
    color1 = "Celeste",
    cantPelo = 30
}

bellota = ChicaSuperpoderosa{
    color1 = "Verde",
    cantPelo = 50
}

chicaLider listaChicas = findOrElse (esRojo) (head listaChicas) listaChicas

esRojo chica = (color1 chica) == "Rojo"