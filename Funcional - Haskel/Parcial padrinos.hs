import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}

-- Punto A

type Habilidad = String
type Deseo = Chico -> Chico

data Chico = Chico {
    nombre :: String,
    edad :: Int,
    habilidades :: [Habilidad],
    deseos :: [Deseo]
} deriving (Show)

timmy  = Chico {
    nombre = "Timmy",
    edad = 10,
    habilidades = ["mirar television","jugar en la pc"],
    deseos = [aprenderHabilidades ["Jugar al futbol"],serMayor]
} 

chester  = Chico {
    nombre = "Chester",
    edad = 15,
    habilidades = ["patinar","ser un supermodelo noruego"],
    deseos = [aprenderHabilidades ["Jugar al futbol"],serMayor]
} 

-- A1

aprenderHabilidades :: [Habilidad] -> Deseo
aprenderHabilidades habilidades1 chico = chico {habilidades = (habilidades chico) ++ habilidades1}

serGrosoEnNeedForSpeed :: Deseo
serGrosoEnNeedForSpeed chico = 
    chico {habilidades = (habilidades chico) ++ (map (("Jugar need for speed" ++).(" " ++).show) [1..]) }

serMayor :: Deseo
serMayor chico = chico {edad = 18}

-- A2

type PadrinosMagicos = Chico -> Chico

wanda :: PadrinosMagicos
wanda  =  (madurar . eliminarPrimerDeseo .cumplirPrimerDeseo)

cumplirPrimerDeseo chico = head (deseos chico) chico

eliminarPrimerDeseo chico = chico {deseos = drop 1 (deseos chico)}

madurar chico = chico {edad = (edad chico) + 1}

cosmo :: PadrinosMagicos
cosmo = desMadurar

desMadurar chico = chico {edad = div (edad chico) 2}

muffinMagico :: PadrinosMagicos
muffinMagico  = (borrarDeseos . cumplirTodosLosDeseos)
    
cumplirTodosLosDeseos chico = foldl (cumplirDeseo) chico (deseos chico)

borrarDeseos chico = chico {deseos = []}

cumplirDeseo chico deseo = deseo chico


-- Punto B

-- B1   

tieneHabilidad habilidad chico = any (== habilidad) (habilidades chico)

esSuperMaduro chico
    | esMayorEdad chico && sabeManejar chico = True
    | otherwise = False

esMayorEdad chico = (edad chico) > 18

sabeManejar chico = any (== "manejar") (habilidades chico)

noEsTimmy chico = (nombre chico) /= "Timmy"

-- B2

data Chica = Chica{
    nombre1 :: String,
    condicion :: Chico -> Bool
} deriving (Show)

trixie = Chica{
    nombre1 = "Trixie Tang",
    condicion = noEsTimmy
}


vicky = Chica{
    nombre1 = "Vicky",
    condicion = tieneHabilidad "ser un supermodelo noruego"
}

juana = Chica{
    nombre1 = "Juana",
    condicion = tieneHabilidad "ser futbolista"
}

-- B2A

quienConquistaA chica losPretendientes
    | length ((obtenerPretendientes (chica)) losPretendientes) /= 0 = 
        (obtenerElPrimero . (obtenerPretendientes (chica))) losPretendientes
    | otherwise = obtenerElUlitmo losPretendientes


obtenerPretendientes chica losPretendientes = filter (condicion chica) losPretendientes

obtenerElPrimero lista = head lista

obtenerElUlitmo losPretendientes = last losPretendientes


-- Punto C

raul  = Chico {
    nombre = "Raul",
    edad = 15,
    habilidades = ["mirar television","jugar en la pc","matar","gobernar","correr","saltar"],
    deseos = [aprenderHabilidades ["Jugar al futbol"],serMayor]
} 

pedro  = Chico {
    nombre = "Pedro",
    edad = 13,
    habilidades = ["mirar television","jugar en la pc","correr","saltar","matar"],
    deseos = [aprenderHabilidades ["Jugar al futbol"],serMayor]
} 
-- C1

infractoresDeDaRules  = obtenerNombres . obtenerChicos 

obtenerNombres = map nombre 

obtenerChicos  =  filter (tieneDeseosProhibidos) 

tieneDeseosProhibidos chico = any (habilidadesProhibidas) (take 5 (habilidades chico))

habilidadesProhibidas habilidad = habilidad == "enamorar" || habilidad == "matar" || habilidad == "dominar el mundo"