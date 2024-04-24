import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}

-- Punto 1

type Condicion = Viaje -> Bool

data Cliente = Cliente {
    nombre1 :: String,
    direccion :: String
} deriving (Show)

data Chofer = Chofer{
    nombre :: String,
    klm :: Int,
    viajesQueTomo :: [Viaje],
    condicion :: Condicion
} deriving (Show)

data Viaje = Viaje {
    fechaParticular :: Int,
    cliente :: Cliente,
    costo :: Int
} deriving (Show)


-- Punto 2

cualquierViaje :: Condicion
cualquierViaje _ = True

viajesMayorA200 :: Condicion
viajesMayorA200  = ((>200).costo)

nombreClienteMayorA :: Int -> Condicion
nombreClienteMayorA cantidad  = (> cantidad).length.nombre1.cliente

noVivirEn :: String -> Condicion
noVivirEn zona =  (/= zona).direccion.cliente


-- Punto 3

lucas = Cliente {
    nombre1 = "Lucas",
    direccion = "Victoria"
}

daniel = Chofer{
    nombre = "Daniel",
    klm = 23500,
    viajesQueTomo = [viaje1],
    condicion = noVivirEn "Olivos"
}

viaje1 = Viaje {
    fechaParticular = 20042017,
    cliente = lucas,
    costo = 150
}

viaje2 = Viaje {
    fechaParticular = 22042017,
    cliente = lucas,
    costo = 200
}



alejandra = Chofer{
    nombre = "Alejandra",
    klm = 180000,
    viajesQueTomo = [],
    condicion = cualquierViaje
}

-- Punto 4

puedeTomarViaje ::  Viaje -> Chofer -> Bool
puedeTomarViaje  viaje chofer= (condicion chofer) viaje

-- Punto 5

liquidacionDe :: Chofer -> Int
liquidacionDe  = sum.map (costo).viajesQueTomo 


-- Punto 6

-- a

choferesPosibles :: Viaje -> [Chofer] -> [Chofer]
choferesPosibles viaje listaChoferes  = filter (puedeTomarViaje (viaje)) listaChoferes

-- b

choferConMenosViaje :: [Chofer] -> Chofer
choferConMenosViaje [chofer] = chofer
choferConMenosViaje (chofer1:choferes) 
    | length (viajesQueTomo chofer1) > length (viajesQueTomo(head choferes)) = choferConMenosViaje choferes
    | otherwise = choferConMenosViaje (chofer1:(drop 1 choferes))

-- c

efectuarViaje :: Viaje -> Chofer -> Chofer
efectuarViaje viaje chofer = chofer {viajesQueTomo = (viajesQueTomo chofer) ++ [viaje]}


-- Punto 7

nito = Chofer{
    nombre = "Nito Infy",
    klm = 70000,
    viajesQueTomo = repetirViaje viajeInfinito,
    condicion = nombreClienteMayorA 2
}

viajeInfinito = Viaje {
    fechaParticular = 11032017,
    cliente = lucas,
    costo = 50
}

repetirViaje viaje = viaje : repetirViaje viaje