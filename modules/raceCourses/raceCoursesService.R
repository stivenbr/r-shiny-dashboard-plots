# Get name by print columns in view
tableColumns <- function(data){
  data <- data %>% 
    dplyr::select(NAME, TYPE, TRACKHANDEDNESS, REGION, LATITUDE, LONGITUDE) %>% 
    dplyr::rename(Nombre = NAME, Categoria = TYPE, Sentido = TRACKHANDEDNESS, Region = REGION, Latitud = LATITUDE, Longitud = LONGITUDE)
  return(data)
}