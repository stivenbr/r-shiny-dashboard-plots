# Get name by print columns in view
tableColumns <- function(data){
  data <- data %>% 
    dplyr::select(NAME, DIVISIONSEQUENCE, FIXTURETYPE, RACEDATE, DISTANCEVALUE, SEXLIMIT, AGELIMIT, RACECRITERIAMINIMUMWEIGHT, PRIZEAMOUNT) %>% 
    dplyr::rename(Ubicacion = NAME, Manga = DIVISIONSEQUENCE, Categoria =FIXTURETYPE, Fecha = RACEDATE, Distancia = DISTANCEVALUE, Sexo = SEXLIMIT, Edad = AGELIMIT, Peso = RACECRITERIAMINIMUMWEIGHT, Premio = PRIZEAMOUNT)
  return(data)
}