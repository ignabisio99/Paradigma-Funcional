{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}


-- Punto 1

type Idioma = String

data Turista = Turista {
    
    nivelCansancio :: Int,
    nivelStress :: Int,
    viajaSolo :: Bool,
    idiomas :: [Idioma]
} deriving (Show)


ana :: Turista
ana = Turista {
    nivelCansancio = 0,
    nivelStress = 21,
    viajaSolo = False,
    idiomas = ["Espanol"]
}

beto :: Turista
beto = Turista {
    nivelCansancio = 15,
    nivelStress = 15,
    viajaSolo = True,
    idiomas = ["Aleman"]
}

cathi :: Turista
cathi = Turista {
    nivelCansancio = 15,
    nivelStress = 15,
    viajaSolo = True,
    idiomas = ["Aleman","Catalan"]
}

-- Punto 2

type Excursion = Turista -> Turista

cambiarNivelCansancio nivel turista  = turista {nivelCansancio = (nivelCansancio turista) + nivel}

cambiarNivelStress nivel turista = turista {nivelStress = (nivelStress turista) + nivel}

cambiarNivelStressPorcentual nivel turista = cambiarNivelStress (div (nivel * nivelStress turista) 100) turista

irALaPlaya :: Excursion
irALaPlaya turista 
    | (viajaSolo turista) = cambiarNivelCansancio 5 turista
    | otherwise = cambiarNivelStress (-1) turista


apreciarElementoPaisaje :: String -> Excursion
apreciarElementoPaisaje elemento turista  = cambiarNivelStress (-length elemento) turista


salirHablarIdioma :: Idioma -> Excursion
salirHablarIdioma idioma turista = turista {idiomas = (idiomas turista) ++ [idioma], viajaSolo = False }


-- 4 minutos = 1 intensidad
-- x minutos = y intensidad

caminar :: Int -> Excursion
caminar minutos turista = ( (cambiarNivelCansancio (div minutos  4)) . (cambiarNivelStress (-(div minutos  4))) ) turista


paseoEnBarco :: String -> Excursion
paseoEnBarco marea turista 
    | marea == "Fuerte" = (cambiarNivelStress 6 . cambiarNivelCansancio 10) turista
    | marea == "Moderada" = turista
    | marea == "Tranquila" = ((salirHablarIdioma "Aleman").(apreciarElementoPaisaje "Mar"). (caminar 10)) turista


-- 2a

hacerExcursion excursion  = (cambiarNivelStressPorcentual (-10). excursion) 

-- 2b

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun indice turista excursion = deltaSegun indice (hacerExcursion excursion turista ) turista

-- 2c

excursionEducativa turista excursion = (deltaExcursionSegun (length . idiomas) turista excursion) >0

excursionesDesestresantes turista = filter (esDesestresante turista)

esDesestresante turista = (<= -3) . deltaExcursionSegun nivelStress turista

-- Punto 3

type Tour = [Excursion]



completo :: Tour
completo = [caminar 20,apreciarElementoPaisaje "cascada",caminar 40, irALaPlaya,salirHablarIdioma "Melmacquiano"]

ladoB :: Excursion -> Tour
ladoB excursion = [paseoEnBarco "Tranquila",excursion,caminar 120]

islaVecina :: String -> Tour
islaVecina marea 
    | marea == "Fuerte" = [paseoEnBarco "Fuerte", apreciarElementoPaisaje "lago", paseoEnBarco "Fuerte"]
    | otherwise = [paseoEnBarco "Fuerte", irALaPlaya, paseoEnBarco "Fuerte"]

-- 3a 

hacerUnTour turista tour = foldl (flip hacerExcursion) (cambiarNivelStress (length tour) turista) tour

-- 3b

algunTourEsConvincente turista listaTours = any (esConvincente turista) listaTours


esConvincente turista tour = (any (dejaAcompaniado turista) . excursionesDesestresantes turista) tour


dejaAcompaniado turista = not . viajaSolo . flip hacerExcursion turista

-- 3c


efectividad tour = sum . map (espiritualidadAportada tour) . filter (flip esConvincente tour)

espiritualidadAportada tour = negate . deltaRutina tour

deltaRutina tour turista = deltaSegun nivelDeRutina (hacerUnTour turista tour) turista

nivelDeRutina turista = nivelStress turista + nivelStress turista


-- Punto 4

-- 4a
playasInfinitas :: Tour
playasInfinitas = cycle [irALaPlaya]

-- 4b
{- Para ana, el tour de playasInfinitas si es convincente ya que ella ya viajó acompañada y como irALaPlaya cuando 
viajas acompañado te vaja 1 punto el nivel de stress, luego de visistar 3 playas el tour ya va a quedar como convincente
sin tener que evaluar las infinitas playas.
En cambio, para Beto, como el viaja solo y el tour es de irAlaPlaya, nunca se va a quedar acompañado ni va a poder
bajar su nivel de stress por lo tanto va a diverger

-}

-- 4c
{- Nunca se va a poder conocer la efectividad del tour para cualquier persona ya que como el tour es infinito 
    (se hace la excursion infinitamente de irALaPlaya), nunca se va a poder terminar de evaluar por lo que diverge. 
    Si fuese con una lista de personas vacia, ahi si convegería a un numero el cual seria 0
-}