# Get name by print columns in view
tableColumns <- function(data){
  data <- data %>% 
    dplyr::select(ENTRYID,ENTRYNAME,TOTALRUN,TOTALWINS) %>% 
    dplyr::rename(Id = ENTRYID, Nombre = ENTRYNAME, TotalCarreras = TOTALRUN, TotalGanadas = TOTALWINS)
  return(data)
}