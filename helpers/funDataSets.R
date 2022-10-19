library(dplyr)
library(tidyr)
library(DT)
library(plotly)

#Corrección del Betting Ratio al estar expresado en una cadena de caracteres
corrigeResults <- function(results){
  results = tidyr::separate(results, col = BETTINGRATIO, into = c("divisor","dividendo"), sep = "/", remove=TRUE)
  results = results %>% dplyr::mutate(BETTINGRATIO = as.integer(divisor)/ as.integer(dividendo))
  results = results %>% dplyr::select(- c("divisor", "dividendo"))
  results = results %>% dplyr::filter(YEAR == 2021)
  return(results)
}

corrigeHorses <- function(horses){
  #Da valor al sexo no especificado
  horses <- horses %>% dplyr::mutate(SEX = ifelse(SEX == "", "UNREGISTERED", SEX))
  return(horses)
}

#FUNCION DE CARGA DE DATASET POR NOMBRE
cargaDataSet <- function(nombreFichero){
   salida <- switch(nombreFichero,
          "horses" = {
            data <- read.csv('./data/horses.csv')
            salida <- corrigeHorses(data)
            salida
          },
            
          "jockeys" = read.csv('./data/jockeys.csv'),
          "owners" = read.csv('./data/owners.csv'),
          "racecourses" = read.csv('./data/racecourses.csv'),
          "races" = read.csv('./data/races.csv'),
          "trainers" = read.csv('./data/trainers.csv'),
          "results" = {
            data <- read.csv('./data/Results_Global_2021.csv')
            salida <- corrigeResults(data) #Aplicamos corrección de bettingRatio
            salida
          }
          )
   return(salida)
}

#FUNCIONES DE FILTRADO DE DATASET TRAINERS
#Basicas
trainersLicenceFilter <- function (dataset, licence){
  dataset <- dataset %>% dplyr::filter(!is.na(LICENCETYPE))
  salida <- dataset %>% dplyr::filter(LICENCETYPE == licence)
  return(salida)
}

#Encapsulada
trainersFilter <- function (dataset, licence){
  if (licence != "All") salida <- trainersLicenceFilter(dataset, licence)
  else salida <- dataset
#  salida <- arrange(salida, NUMBEROFDAYSSINCELASTWIN)
  return(salida)
}

#FUNCIONES DE FILTRADO DE DATASET OWNERS
#Basicas
ownersChampionshipTypeFilter <- function (dataset, championshipType){
  dataset <- dataset %>% dplyr::filter(!is.na(CHAMPIONSHIPTYPE))
  salida <- dataset %>% dplyr::filter(CHAMPIONSHIPTYPE == championshipType)
  return(salida)
}

ownersTotalChampionshipRunsFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(TOTALOWNERCHAMPIONSHIPSRUNS))
  salida <- dataset %>% dplyr::filter(TOTALOWNERCHAMPIONSHIPSRUNS >= min & TOTALOWNERCHAMPIONSHIPSRUNS <= max)
  return(salida)
}

ownersChampionshipWinRatioFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(TOTALOWNERCHAMPIONSHIPWINS))
  dataset <- dataset %>% dplyr::filter(!is.na(TOTALOWNERCHAMPIONSHIPSRUNS))
  dataset <- dataset %>% dplyr::mutate(WINNINGRATIO = round(TOTALOWNERCHAMPIONSHIPWINS / TOTALOWNERCHAMPIONSHIPSRUNS,2))
  salida <- dataset %>% dplyr::filter(WINNINGRATIO >= min & WINNINGRATIO <= max)
  return(salida)
}

#Encapsulada
ownersFilter <- function (dataset, championshipType, minRuns, maxRuns, minWinRatio, maxWinRatio){
  if (championshipType != 'All') salida <- ownersChampionshipTypeFilter(dataset, championshipType)
  else salida <- dataset
  salida <- ownersTotalChampionshipRunsFilter(salida,minRuns,maxRuns)
  salida <- ownersChampionshipWinRatioFilter(salida,minWinRatio,maxWinRatio)
  return(salida)
}

#FUNCIONES DE FILTRADO DE DATASET JOCKEYS
#Basicas
jockeysTotalRunFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(TOTALRUN))
  salida <- dataset %>% dplyr::filter(TOTALRUN >= min & TOTALRUN <= max)
  return(salida)
}
jockeysWinRatioFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(TOTALRUN))
  dataset <- dataset %>% dplyr::filter(!is.na(TOTALWINS))
  dataset <- dataset %>% dplyr::mutate(WINNINGRATIO = round(TOTALWINS / TOTALRUN,2))
  salida <- dataset %>% dplyr::filter(WINNINGRATIO >= min & WINNINGRATIO <= max)
  return(salida)
}

#Encapsulada
jockeysFilter <- function(dataset, minRun, maxRun, minWin, maxWin){
  salida <- jockeysTotalRunFilter(dataset,minRun,maxRun)
  salida <- jockeysWinRatioFilter(salida,minWin,maxWin)
  salida <- arrange(salida, desc(WINNINGRATIO))
  return(salida)
}
#FUNCIONES DE FILTRADO DE DATASET HORSES
#Basicas
horsesSexFilter <- function (dataset, sex){
  dataset <- dataset %>% dplyr::filter(!is.na(SEX))
  salida <- dataset %>% dplyr::filter(SEX == sex)
  return(salida)
}

horsesAgeFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(AGE2021))
  salida <- dataset %>% dplyr::filter(AGE2021 >= min & AGE2021 <= max)
  return(salida)
}

horsesRatingFilter <- function (dataset, ratingType){
  salida <- switch(ratingType,
                   "AWT" = dataset %>% dplyr::filter(!is.na(RATINGAWT)),
                   "CHASE" = dataset %>% dplyr::filter(!is.na(RATINGCHASE)),
                   "FLAT" = dataset %>% dplyr::filter(!is.na(RATINGFLAT)),
                   "HURDLE" = dataset %>% dplyr::filter(!is.na(RATINGHURDLE))
                   )
  return(salida)
}

#Encapsulada
horsesFilter<- function(dataset, sex, minAge, maxAge, ratingType){
  if (sex != "All") salida <- horsesSexFilter(dataset, sex)
  else salida <- dataset
  
  salida <- horsesAgeFilter(salida, minAge, maxAge)
  
  if (ratingType != "All") salida <- horsesRatingFilter(salida, ratingType)

  return(salida)
}

#FUNCIONES DE FILTRADO DE DATASET RACECOURSES
#Basicas
raceCoursesTypeFilter <- function (dataset, type){
  dataset <- dataset %>% dplyr::filter(!is.na(TYPE))
  salida <- dataset %>% dplyr::filter(TYPE == type)
  return(salida)
}

raceCoursesHandednessFilter <- function (dataset, handedness){
  dataset <- dataset %>% dplyr::filter(!is.na(TRACKHANDEDNESS))
  salida <- dataset %>% dplyr::filter(TRACKHANDEDNESS == handedness)
  return(salida)
}

#Encapsulada
raceCoursesFilter <- function(dataset, type, handedness){
  if (type != "All") salida <- raceCoursesTypeFilter(dataset, type)
  else salida <- dataset
  
  if (handedness != "All") salida <- raceCoursesHandednessFilter(salida, handedness)

  return(salida)
}

#FUNCIONES DE FILTRADO DE DATASET RACES
#Basicas
raceTypeFilter <- function (dataset, type){
  dataset <- dataset %>% dplyr::filter(!is.na(FIXTURETYPE))
  salida <- dataset %>% dplyr::filter(FIXTURETYPE == type)
  return(salida)
}

raceSexLimitFilter <- function (dataset, sex){
  dataset <- dataset %>% dplyr::filter(!is.na(SEXLIMIT))
  salida <- dataset %>% dplyr::filter(SEXLIMIT == sex)
  return(salida)
}

racePrizeAmountFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(PRIZEAMOUNT))
  salida <- dataset %>% dplyr::filter(PRIZEAMOUNT >= min & PRIZEAMOUNT <= max)
  return(salida)
}

#Encapsulada
racesFilter <- function(dataset, type, sex, prizeMin, prizeMax){
  if (type != "All") salida <- raceTypeFilter(dataset, type)
  else salida <- dataset
  
  salida <- raceSexLimitFilter(salida, sex) #No hace falta incorporar All por estar ya dentro de los valores posibles
  
  salida <- racePrizeAmountFilter(salida, prizeMin, prizeMax)

  return(salida)
}

#FUNCIONES DE FILTRADO DE DATASET RACERESULTS
#Basicas
resultsAgeFilter <- function (dataset, min, max){
  dataset <- dataset %>% dplyr::filter(!is.na(AGEYEAR))
  salida <- dataset %>% dplyr::filter(AGEYEAR >= min & AGEYEAR <= max)
  return(salida)
}

resultsSexFilter <- function (dataset, sex){
  dataset <- dataset %>% dplyr::filter(!is.na(SEXTYPE))
  salida <- dataset %>% dplyr::filter(SEXTYPE == sex)
  return(salida)
}

resultsRaceCriteriaFilter <- function (dataset, type){
  dataset <- dataset %>% dplyr::filter(!is.na(RACECRITERIARACETYPE))
  salida <- dataset %>% dplyr::filter(RACECRITERIARACETYPE == type)
  return(salida)
}

resultsBettingRatioFilter <- function (dataset, ratioMin, ratioMax){
  dataset <- dataset %>% dplyr::filter(!is.na(BETTINGRATIO))
  dataset <- dataset %>% dplyr::filter(BETTINGRATIO >= ratioMin & BETTINGRATIO <= ratioMax)
  salida <- dataset %>% dplyr::arrange(desc(BETTINGRATIO))
  return(salida)
}

resultsFinishPosFilter <- function (dataset, position, worse){
  dataset <- dataset %>% dplyr::filter(!is.na(RESULTFINISHPOS))
  if (worse) dataset <- dataset %>% dplyr::filter(RESULTFINISHPOS >= position)
  else dataset <- dataset %>% dplyr::filter(RESULTFINISHPOS <= position)
  salida <- dataset %>% dplyr::arrange(RACEID, RESULTFINISHPOS)
  return(salida)
}

resultsWeightValueFilter <- function (dataset, weight, over){
  dataset <- dataset %>% dplyr::filter(!is.na(WEIGHTVALUE))
  if (over){ salida <- dataset %>% dplyr::filter(WEIGHTVALUE >= weight) }
  else {salida <- dataset %>% dplyr::filter(WEIGHTVALUE <= weight)}
  return(salida)
}

#Encapsulada
resultsFilter <- function(dataset, minAge, maxAge, sex, raceCriteria, bettingRatioMin, bettingRatioMax){
  salida <- resultsAgeFilter(dataset, minAge, maxAge)
  
  if(sex != "All") salida <- resultsSexFilter(salida, sex)
    
  if(raceCriteria != "All") salida <- resultsRaceCriteriaFilter(salida, raceCriteria)
  
  salida <- resultsBettingRatioFilter(salida, bettingRatioMin, bettingRatioMax)

#  if(position != 0) salida <- resultsFinishPosFilter(salida, position, worse)
  
#  if(weight != 0) salida <- resultsWeightValueFilter(salida, weight, over)
  
  return (salida)
}

#FUNCIONES DE VALORES POSIBLES Y MAXIMOS Y MINIMOS
#trainers
trainersLicenceValues <- function(dataset){
  return(c("All", unique(dataset$LICENCETYPE)))
}

#owners
ownersChampionshipTypeValues <- function(dataset){
  return(c("All", unique(dataset$CHAMPIONSHIPTYPE)))
}

ownersChampionshipRunMax <- function(dataset){
  return(max(dataset$TOTALOWNERCHAMPIONSHIPSRUNS))
}

ownersChampionshipRunMin <- function(dataset){
  return(min(dataset$TOTALOWNERCHAMPIONSHIPSRUNS))
}

ownersChampionshipWinRatioMax <- function(dataset){
  return(1)
}

ownersChampionshipWinRatioMin <- function(dataset){
  return(0)
}

#jockeys
jockeysRunMax <- function(dataset){
  return(max(dataset$TOTALRUN))
}

jockeysRunMin <- function(dataset){
  return(min(dataset$TOTALRUN))
}

jockeysWinRatioMax <- function(dataset){
  return(1)
}

jockeysWinRatioMin <- function(dataset){
  return(0)
}

#horses
horsesSexValues <- function(dataset){
  return(c("All", unique(dataset$SEX)))
}

horsesAgeMax <- function(dataset){
  return(max(dataset$AGE2021))
}

horsesAgeMin <- function(dataset){
  return(min(dataset$AGE2021))
}

horsesRatingTypeValues <- function(dataset){
  return(c("AWT", "CHASE", "FLAT", "HURDLE"))
}


#racecourses
raceCoursesTypeValues <- function(dataset){
  return(c("All", unique(dataset$TYPE)))
}

raceCoursesHandednessValues <- function(dataset){
  return(c("All", unique(dataset$TRACKHANDEDNESS)))
}

#races
racesTypeValues <- function(dataset){
  return(c("All", unique(dataset$FIXTURETYPE)))
}

racesSexLimitValues <- function(dataset){
  return(c(unique(dataset$SEXLIMIT)))
}

racesPrizeMax <- function(dataset){
  dataset <- dataset %>% dplyr::filter(!is.na(PRIZEAMOUNT)) #Necesario eliminar los NA
  return(max(dataset$PRIZEAMOUNT))
}

racesPrizeMin <- function(dataset){
  dataset <- dataset %>% dplyr::filter(!is.na(PRIZEAMOUNT)) #Necesario eliminar los NA
  return(min(dataset$PRIZEAMOUNT))
}

#results
resultsAgeMax <- function(dataset){
  return(max(dataset$AGEYEAR))
}

resultsAgeMin <- function(dataset){
  return(min(dataset$AGEYEAR))
}

resultsSexTypeValues <- function(dataset){
  return(c("All", unique(dataset$SEXTYPE)))
}

resultsRaceTypeValues <- function(dataset){
  return(c("All", unique(dataset$RACECRITERIARACETYPE)))
}

resultsBettingRatioMax <- function(dataset){
  dataset <- dataset %>% dplyr::filter(!is.na(BETTINGRATIO))
  return(max(dataset$BETTINGRATIO))
}

resultsBettingRatioMin <- function(dataset){
  dataset <- dataset %>% dplyr::filter(!is.na(BETTINGRATIO))
  return(min(dataset$BETTINGRATIO))
}

#FUNCIONES DE VISUALIZACION DE TABLAS
#Caballos
horsesTableView <- function(dataset){
  dataset <- dataset %>% select(NAME, DATEOFBIRTH,SEX, TRAINERNAME, OWNERNAME, RATINGAWT, RATINGCHASE, RATINGFLAT, RATINGHURDLE)
  dataset <- dataset %>% rename(Nombre = NAME, Nacimiento = DATEOFBIRTH, Sexo = SEX, Entrenador = TRAINERNAME, Propietario = OWNERNAME, PuntosAWT = RATINGAWT, PuntosCHASE = RATINGCHASE, PuntosFLAT = RATINGFLAT, puntosHURDLE = RATINGHURDLE)
  return(dataset)
}

#Jockeys
jockeysTableView <- function(dataset){
  dataset <- dataset %>% select(ENTRYNAME,TOTALRUN,TOTALWINS)
  dataset <- dataset %>% rename(Nombre = ENTRYNAME, Carreras = TOTALRUN, Victorias = TOTALWINS)
  return(dataset)
}

#Entrenadores
trainersTableView <- function(dataset){
  dataset <- dataset %>% select(FULLNAME, TRAINERSTYLE, LICENCETYPE, COUNTY, NUMBEROFDAYSSINCELASTWIN)
  dataset <- dataset %>% rename(Nombre = FULLNAME, Apodo = TRAINERSTYLE, Licencia = LICENCETYPE, Region = COUNTY, DiasUltimaVictoria = NUMBEROFDAYSSINCELASTWIN)
  return(dataset)
}

#Propietarios
ownersTableView <- function(dataset){
  dataset <- dataset %>% select(RANKING, OWNERNAME, CHAMPIONSHIPTYPE, LEADINGEARNERHORSE, TOTALOWNERCHAMPIONSHIPSRUNS, TOTALOWNERCHAMPIONSHIPWINS, TOTALOWNERPRIZEMONEYWON)
  dataset <- dataset %>% rename(Ranking = RANKING, Nombre = OWNERNAME, Categoria = CHAMPIONSHIPTYPE, CaballoPrincipal = LEADINGEARNERHORSE, Carreras = TOTALOWNERCHAMPIONSHIPSRUNS, Victorias = TOTALOWNERCHAMPIONSHIPWINS, Premios = TOTALOWNERPRIZEMONEYWON)
  return(dataset)
}

#Carreras
racesTableView <- function(dataset){
  dataset <- dataset %>% select(NAME, DIVISIONSEQUENCE, FIXTURETYPE, RACEDATE, DISTANCEVALUE, SEXLIMIT, AGELIMIT, RACECRITERIAMINIMUMWEIGHT, PRIZEAMOUNT)
  dataset <- dataset %>% rename(Ubicacion = NAME, Manga = DIVISIONSEQUENCE, Categoria =FIXTURETYPE, Fecha = RACEDATE, Distancia = DISTANCEVALUE, Sexo = SEXLIMIT, Edad = AGELIMIT, Peso = RACECRITERIAMINIMUMWEIGHT, Premio = PRIZEAMOUNT)
  return(dataset)
}

#Trazados
racecoursesTableView <- function(dataset){
  dataset <- dataset %>% select(NAME, TYPE, TRACKHANDEDNESS, REGION, LATITUDE, LONGITUDE)
  dataset <- dataset %>% rename(Nombre = NAME, Categoria = TYPE, Sentido = TRACKHANDEDNESS, Region = REGION, Latitud = LATITUDE, Longitud = LONGITUDE)
  return(dataset)
}

#Resultados
resultsTableView <- function(dataset){
  
}
