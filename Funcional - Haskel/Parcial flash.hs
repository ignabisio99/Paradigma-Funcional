import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}



-- Punto 1

data Personaje = Personaje {
    vidaInicial :: Int,
    nombreCompleto :: String,
    tipo :: String,
    poderes :: [Poder]
} deriving (Show)


reverseFlash = Personaje{
    vidaInicial = 450,
    nombreCompleto = "Harrison Wells",
    tipo = "villano",
    poderes = [viajarEnElTiempo]
}

godSpeed = Personaje{
    vidaInicial = 300,
    nombreCompleto = "GodSpeed",
    tipo = "villano",
    poderes = [viajarEnElTiempo]
}

iris = Personaje{
    vidaInicial = 100,
    nombreCompleto = "Iris West",
    tipo = "cientifico",
    poderes = [dispararArma 30]
}

cisco = Personaje{
    vidaInicial = 300,
    nombreCompleto = "Cisco Ramon",
    tipo = "cientifico",
    poderes = [dispararArma 25]
}

-- Punto 2

puedenPelear personaje1 personaje2 
    | (tipo personaje1) == "cientifico" || tipo (personaje2) == "cientifico" = True
    | (tipo personaje1) /= (tipo personaje2) = True
    | otherwise = False

-- Punto 3

esGrupoBienArmado grupoPersonajes enemigo = 
    length (filter (puedenPelear (enemigo)) grupoPersonajes) == length grupoPersonajes

{-Punto 4

esPosibleGanar grupoPersonajes enemigo = 
    esGrupoBienArmado grupoPersonajes enemigo && any (sonIniciales "HR") grupoPersonajes

sonIniciales iniciales  = (== iniciales ) . obtenerIniciales . nombreYApellido . nombreCompleto   

obtenerIniciales ((x:_),(y:_)) = x ++ y

-- Punto 5
-}

type Poder = Personaje -> Personaje

viajarEnElTiempo :: Poder
viajarEnElTiempo  = quitarTodosLosPoderes

quitarTodosLosPoderes enemigo = enemigo {poderes = []}

tirarRayo :: Poder
tirarRayo = (quitarHabilidad . quitarVida 50)

quitarVida numero enemigo = enemigo{vidaInicial = (vidaInicial enemigo) - numero}

quitarHabilidad enemigo = enemigo{poderes = drop 1 (poderes enemigo)}

dispararArma :: Int -> Poder
dispararArma calibre enemigo = quitarVida calibre enemigo

hablarHastaElCansancio :: Poder
hablarHastaElCansancio enemigo
    | (tipo enemigo) /= "villano" = enemigo {nombreCompleto = ""}
    | otherwise = enemigo


correr :: [Int] -> Poder
correr velocidades enemigo = foldl correrUnaVez enemigo velocidades

correrUnaVez enemigo velocidad = quitarVida(10+ 5* velocidad) enemigo -- rompe x tipos

harrison2 = Personaje{
    vidaInicial = 300,
    nombreCompleto = "Harrison Wells Tierra2",
    tipo = "cientifico",
    poderes = [correr [1..10],dispararArma 32]
}

harrison32 = Personaje{
    vidaInicial = 300,
    nombreCompleto = "Harrison Wells Tierra2",
    tipo = "cientifico",
    poderes = [hablarHastaElCansancio]
}

deathStroke = Personaje{
    vidaInicial = 800,
    nombreCompleto = "Death Stroke",
    tipo = "villano",
    poderes = [dispararArma 32,dispararArma 32]
}

-- Punto 6

-- a

quedaKo grupoPersonajes oponente = (vidaInicial (atacarConTodosLosPoderes grupoPersonajes oponente)) < 10

atacarConTodosLosPoderes grupoPersonajes oponente = foldl (usarPoderes) oponente grupoPersonajes

usarPoderes oponente personaje  = foldl (atacarPoder) oponente (poderes personaje)

atacarPoder oponente poder = poder oponente

-- c

quedoInservible grupoPersonajes oponente
    | (tipo oponente) == "villano" && (quedaKo grupoPersonajes oponente) = True
    | (tipo oponente) == "heroe" &&  (  (nombreCompleto (atacarConTodosLosPoderes grupoPersonajes oponente)) == "") = True
    | (tipo oponente) == "cientifico" &&  ( length (poderes oponente) == 0) = True
    | otherwise = False

-- Punto 7

flash = Personaje{
    vidaInicial = 500,
    nombreCompleto = "Barry allen",
    tipo = "heroe",
    poderes = [correr [1..]]
}

{- No, si flash participa en una pelea como atacante, al usar sus poderes, como corre al infinito, nunca va a terminar de
poder calcular su daño total, por lo que el algoritmo va a diverger


Si, flash puede ser atacado con esos dos poderes ya que viajar en el tiempo le borra absolutamente todas las habilidades
y tirarElRayo el borra una habilidad y como flash solo tiene la habilidad de correr, se la borra. De esta forma,
los 2 poderes lo dejan a flash con una lista vacia de poderes
-}

