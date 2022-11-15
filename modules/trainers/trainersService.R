# Get name by print columns in view
tableColumns <- function(data){
  data <- data %>% 
    dplyr::select(FULLNAME, TRAINERSTYLE, LICENCETYPE, COUNTY, NUMBEROFDAYSSINCELASTWIN) %>% 
    dplyr::rename(Nombre = FULLNAME, Apodo = TRAINERSTYLE, Licencia = LICENCETYPE, Region = COUNTY, DiasUltimaVictoria = NUMBEROFDAYSSINCELASTWIN)
  return(data)
}