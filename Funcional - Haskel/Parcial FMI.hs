import Text.Show.Functions ()
import Data.List()

{- Alumno: Bisio, Ignacio
   Legajo: 172667-5
-}

-- Punto 1

type Recurso = String

data Pais = Pais{
    ingresoPercapita :: Int,
    poblacionActivaPublico :: Int,
    poblacionActivaPrivado :: Int,
    recursos :: [Recurso],
    deuda :: Int
} deriving (Show)

namibia = Pais{
    ingresoPercapita = 4140,
    poblacionActivaPublico = 400000,
    poblacionActivaPrivado = 650000,
    recursos = ["Mineria","Ecoturismo"],
    deuda = 50000000
} 

argentina = Pais{
    ingresoPercapita = 2565,
    poblacionActivaPublico = 360000,
    poblacionActivaPrivado = 800000,
    recursos = ["Futbol","Petroleo"],
    deuda = 55000000
} 

francia = Pais{
    ingresoPercapita = 2565,
    poblacionActivaPublico = 360000,
    poblacionActivaPrivado = 800000,
    recursos = ["Panaderia","Electronica","Petroleo"],
    deuda = 55000000
} 

-- Punto 2

type Receta = Pais -> Pais

prestarNMillones :: Int -> Receta
prestarNMillones millones pais = aumentarDeuda millones pais

aumentarDeuda millones pais = pais {deuda = (deuda pais) + (div (150 * (millones * 1000000)) 100)}


reducirPuestosTrabajoPublico :: Int -> Receta
reducirPuestosTrabajoPublico cantidad pais 
    | cantidad > 100 = pais{poblacionActivaPublico = (poblacionActivaPublico pais) - cantidad,
        ingresoPercapita = (ingresoPercapita pais) - (div (20 * (ingresoPercapita pais)) 100)}
    | otherwise = pais{poblacionActivaPublico = (poblacionActivaPublico pais) - cantidad,
        ingresoPercapita = (ingresoPercapita pais) - (div (15 * (ingresoPercapita pais)) 100)}


darEmpresa :: String -> Receta
darEmpresa empresa pais = pais {deuda = (deuda pais) - 2000000,recursos = filter (/= empresa) (recursos pais)}


establecerBlindaje:: Receta
establecerBlindaje pais = ((prestar) . (reducirPuestosTrabajoPublico 500)) pais

prestar :: Receta
prestar pais = pais {deuda 
    =  (deuda pais) + (div  ((ingresoPercapita pais) * ((poblacionActivaPrivado pais) + (poblacionActivaPublico pais))) 2)}


-- Punto 3

recetaRara :: Receta
recetaRara  =  darEmpresa "Mineria" . prestarNMillones 200 

-- Punto 4

puedenSafar :: [Pais] -> [Pais]
puedenSafar  = filter (any (== "Petroleo").(recursos)) 

totalDeuda :: [Pais] -> Int
totalDeuda = sum . map (deuda)

-- Punto 5
{-estaOrdenado :: Pais -> [Receta] -> Bool
estaOrdenado pais [receta] = True
estaOrdenado pais (receta1:receta2:recetas) 
     = revisarPBI receta1 pais <= revisarPBI receta2 pais && estaOrdenado pais (receta2:recetas)
     where revisarPBI receta = pbi . aplicarReceta receta
-}

-- Punto 6

recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos
{-
    Si un pais tiene recursos naturales infinitos de "Energia" y le aplicamos la funcion de 4a, donde busca que
    contenga el recurso de "Petroleo", el algoritmo va a diverger ya que nunca va a poder terminar de evaluar para saber
    si lo tiene o no.

    Si le aplicamos la funcion 4b, el cual te calcula la deuda, el algoritmo si va a poder converger ya que no le 
    interesa la cantidad de recursos que tenga, ya que ni los va a calcular, esto se debe a la EVALUACION DIFERIDA
-}
