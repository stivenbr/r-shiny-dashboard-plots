# Get name by print columns in view
tableColumns <- function(data){
  data <- data %>% 
    dplyr::select(LOCATION, RACEDATE, DISTANCE,NAME, ENTRYNAME, ownername, SEXTYPE, RACECRITERIARACETYPE, AGEYEAR, BETTINGRATIORESULT, RESULTFINISHPOS) %>% 
    dplyr::rename(Ubicacion = LOCATION, Fecha = RACEDATE, Distancia = DISTANCE, Caballo = NAME, Jockey = ENTRYNAME, Propietario = ownername, Sexo = SEXTYPE, Tipo = RACECRITERIARACETYPE, Edad = AGEYEAR, RatioApuesta = BETTINGRATIORESULT, Posicion = RESULTFINISHPOS)
  return(data)
}