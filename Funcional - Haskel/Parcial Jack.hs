import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}

-- Punto 1


data Elemento = Elemento{
    tipo :: String,
    ataque :: (Personaje -> Personaje),
    defensa :: (Personaje -> Personaje)
} deriving (Show)

data Personaje = Personaje {
    nombre :: String,
    salud :: Float,
    elementos :: [Elemento],
    anioPresente :: Int
} deriving (Show)

alex= Personaje {
    nombre = "Alex",
    salud = 100,
    elementos = [espada,cuchillo],
    anioPresente = 2021
} 

luca= Personaje {
    nombre = "Luca",
    salud = 100,
    elementos = [espada],
    anioPresente = 2021
} 

espada = Elemento{
    tipo = "Malvado",
    ataque = causarDanio 40,
    defensa = meditar
} 

cuchillo = Elemento{
    tipo = "Bueno",
    ataque = causarDanio 130,
    defensa = meditar
} 


mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio anio personaje = personaje {anioPresente = anio}

meditar :: Personaje -> Personaje
meditar personaje = personaje {salud = (salud personaje) + ((salud personaje) / 2)}

causarDanio :: Float -> Personaje -> Personaje
causarDanio danio personaje = personaje {salud = max ((salud personaje) - danio) 0}


-- Punto 2

esMalvado :: Personaje -> Bool
esMalvado  = tieneAlgunObjetoMalvado

tieneAlgunObjetoMalvado personaje = any (=="maldad") (map tipo (elementos personaje))


danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento = (salud personaje) -  (salud ((ataque elemento) personaje))


enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje  = filter (esEnemigoMortal personaje) 

esEnemigoMortal personaje enemigo = (any (puedeMatar personaje) . elementos) enemigo

puedeMatar personaje elemento = danioQueProduce personaje elemento == salud personaje


-- Punto 3

-- a

concentracion :: Int -> Elemento
concentracion nivel = Elemento {
    tipo = "Magia",
    ataque = id,
    defensa = foldl1 (.) (replicate nivel meditar)
}



-- b

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados cantidad = take cantidad (repeat (Elemento {tipo = "Maldad", ataque = causarDanio 1, defensa = id}))


-- c

jack = Personaje {
    nombre = "Jack",
    salud = 300,
    elementos = [concentracion 3,katana],
    anioPresente = 200
} 

katana = Elemento{
    tipo = "Magia",
    ataque = causarDanio 1000,
    defensa = id
}


-- d
aku :: Int -> Float -> Personaje
aku anioViviente cantidadSalud = Personaje {
    nombre = "",
    salud = cantidadSalud,
    elementos = concentracion 4:portalAlFuturo anioViviente:esbirrosMalvados (100 *anioViviente),
    anioPresente = anioViviente
}

portalAlFuturo anioViviente = Elemento{
    tipo ="Magia",
    ataque = mandarAlAnio (2800 + anioViviente),
    defensa = (aku anioViviente.salud)
    }


-- Punto 4

luchar :: Personaje -> Personaje -> (Personaje, Personaje) 

luchar atacante defensor
 |estaMuerto atacante = (defensor, atacante)
 |otherwise = luchar proximoAtacante proximoDefensor
 where proximoAtacante = usarElementos ataque defensor (elementos atacante)
       proximoDefensor = usarElementos defensa atacante (elementos atacante)

estaMuerto personaje = (salud personaje) == 0


usarElementos funcion personaje elementos = foldl afectar personaje (map funcion elementos)

afectar personaje funcion = funcion personaje
