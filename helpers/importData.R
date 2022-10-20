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

importData <- function(nombreFichero){
  salida <- switch(
    nombreFichero,
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