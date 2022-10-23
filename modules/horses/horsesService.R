# Filter data table by table-form-filer
tableFilter <- function(data, name, sex, age, ratingawt, trainerName){
  trainerName <- stringr::str_to_lower(trainerName)
  data <- data %>%
    dplyr::filter(
      if(name != "") stringr::str_detect(str_to_lower(NAME), name) else TRUE,
      if(sex != "TODOS") SEX == sex else TRUE,
      if(age != "TODOS") AGE2021 == age else TRUE,
      if(ratingawt != "TODOS") RATINGAWT == ratingawt else TRUE,
      if(trainerName != "") stringr::str_detect(str_to_lower(TRAINERNAME), trainerName) else TRUE
    )
   
  return(data)
}

# Get name by print columns in view
tableColumns <- function(data){
  data <- data %>% 
    dplyr::select(NAME, AGE2021, DATEOFBIRTH, SEX, TRAINERNAME, OWNERNAME, RATINGAWT, RATINGCHASE, RATINGFLAT, RATINGHURDLE) %>% 
    dplyr::rename(Nombre = NAME, Edad = AGE2021, Nacimiento = DATEOFBIRTH, Sexo = SEX, Entrenador = TRAINERNAME, Propietario = OWNERNAME, PuntosAWT = RATINGAWT, PuntosCHASE = RATINGCHASE, PuntosFLAT = RATINGFLAT, puntosHURDLE = RATINGHURDLE)
  return(data)
}

# get names of columns start with by "ratings"
getColumnsNamesOfRatings <- function(data){
  columns <- colnames(data);
  columnsRating <- columns[startsWith(columns, "RATING")]
  return(columnsRating)
}

# get data rating for plot
getDataRatingForPlot <- function(data){
  data <- data %>%
    dplyr::group_by(AGE2021) %>% # group values by age
    dplyr::summarize(across(starts_with("RATING"), ~ round(mean(.x, na.rm=TRUE), 2))) %>% # Filter columns by name and round values
    reshape2::melt(id="AGE2021") %>% # Convert columns to rows by id
    dplyr::filter(!is.na(value))
  
  return(data)
}