importData <- function(nombreFichero){
  salida <- switch(
    nombreFichero,
      "horses" = importDataHorses(),
      "jockeys" = importDataJockeys(),
      "owners" = importDataOwners(),
      "racecourses" = importDataRaceCourses(),
      "races" = importDataRaces(),
      "trainers" = importDataTrainers(), 
      "results" = importDataResults()
  )
  return(salida)
}

importDataHorses <- function(){
  data <- read.csv('./data/horses.csv')
  data$SEX[data$SEX==""] <- "UNREGISTERED"
  return(data)
}

importDataJockeys <- function(){
  data <- read.csv('./data/jockeys.csv')
  return(data)
}

importDataOwners <- function(){
  data <- read.csv('./data/owners.csv')
  return(data)
}

importDataRaceCourses <- function(){
  data <- read.csv('./data/racecourses.csv')
  return(data)
}

importDataRaces <- function(){
  data <- read.csv('./data/races.csv')
  return(data)
}

importDataTrainers <- function(){
  data <- read.csv('./data/trainers.csv')
  return(data)
}

importDataResults <- function(year = 2021){
  results <- read.csv('./data/Results_Global_2021.csv') %>%
    dplyr::filter(YEAR == year) %>%
    tidyr::separate(col = BETTINGRATIO, into = c("divisor","dividendo"), sep = "/", convert=TRUE) %>%
    dplyr::mutate(BETTINGRATIORESULT = round((divisor/dividendo), 2) ) %>%
    dplyr::select(-c("divisor", "dividendo"))

  return(results)
}