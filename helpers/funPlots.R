library(ggplot2)


#FILTROS ESPECIFICOS:
horsesRatingFilterPlot <- function (dataset, ratingType){
  salida <- switch(ratingType,
                   "AWT" = {
                     dataset <- dataset %>% dplyr::filter(!is.na(RATINGAWT))
                     dataset <- dataset %>% dplyr::group_by(AGE2021)
                     dataset <- dataset %>% dplyr::summarize(RATING = round(mean(RATINGAWT, na.rm=TRUE),2))
                     dataset
                   },
                   "CHASE" = {
                     dataset <- dataset %>% dplyr::filter(!is.na(RATINGCHASE))
                     dataset <- dataset %>% dplyr::group_by(AGE2021)
                     dataset <- dataset %>% dplyr::summarize(RATING = round(mean(RATINGCHASE, na.rm=TRUE),2))
                     dataset
                   },
                   "FLAT" = {
                     dataset <- dataset %>% dplyr::filter(!is.na(RATINGFLAT))
                     dataset <- dataset %>% dplyr::group_by(AGE2021)
                     dataset <- dataset %>% dplyr::summarize(RATING = round(mean(RATINGFLAT, na.rm=TRUE),2))
                     dataset
                   },
                   "HURDLE" = {
                     dataset <- dataset %>% dplyr::filter(!is.na(RATINGHURDLE))
                     dataset <- dataset %>% dplyr::group_by(AGE2021)
                     dataset <- dataset %>% dplyr::summarize(RATING = round(mean(RATINGHURDLE, na.rm=TRUE), 2))
                     dataset
                   }
  )
  return(salida)
}

resultsFilterPlot <- function(data){
  data <- data %>% dplyr::select(NAME, ENTRYNAME, RESULTFINISHPOS) %>% dplyr::filter(RESULTFINISHPOS == 1)
  data <- data %>% dplyr::group_by(NAME, ENTRYNAME) %>% dplyr::summarize(Victorias = sum(RESULTFINISHPOS)) %>% arrange(desc(Victorias))
  data
}

#PLOT FUNCTIONS
#Caballos
plotHorses <- function(horses,ratingType){
  data <- horsesRatingFilterPlot(horses, ratingType)
  plot <- ggplot(data, aes(AGE2021, RATING))
  if(nrow(data) != 0) plot <- plot + geom_point() + geom_line()
  addLabs <- plot + labs(x="Edad", y=paste("Rating",ratingType))
  addTheme <- addLabs + theme_minimal()
  return(addTheme)
}

#Jockeys
plotJockeys <- function(jockeys){
  data <- slice_max(jockeys, n = 10, order_by = WINNINGRATIO, with_ties = FALSE)
  plot <- ggplot(data, aes(ENTRYNAME, WINNINGRATIO))
  if(nrow(data) != 0) plot <- plot + geom_col()
  addLabs <- plot + labs(x="Nombre", y="Ratio Victorias/Carreras")
  addTheme <- addLabs + theme_minimal()
  return(addTheme)
}

#Trainers
plotTrainers <- function(trainers){
  data <- trainers %>% arrange(NUMBEROFDAYSSINCELASTWIN)
  data <- head(data,10)
  plot <- ggplot(data, aes(TRAINERSTYLE, NUMBEROFDAYSSINCELASTWIN))
  if(nrow(data) != 0) plot <- plot + geom_col()
  addLabs <- plot + labs(x="Nombre", y="Días desde última victoria")
  addTheme <- addLabs + theme_minimal()
  return(addTheme)
}

#Owners
plotOwners <- function(owners){
  data <- owners %>% arrange(RANKING)
  data <- head(data,10)
  plot <- ggplot(data, aes(OWNERNAME, TOTALOWNERPRIZEMONEYWON))
  if(nrow(data) != 0) plot <- plot + geom_col()
  addLabs <- plot + labs(x="Nombre", y="Total ganancias acumuladas")
  addTheme <- addLabs + theme_minimal()
  return(addTheme)
}

#Races
plotRaces <- function(races){
  data <- races %>% arrange(PRIZEAMOUNT)
  data <- head(data, 10)
  plot <- ggplot(data, aes(NAME, PRIZEAMOUNT))
  if(nrow(data) != 0) plot <- plot + geom_col()
  addLabs <- plot + labs(x="Carrera", y="Premio")
  addTheme <- addLabs + theme_minimal()
  return(addTheme)
}

#RaceCourses
plotRaceCourses <- function(courses){
  UK <- map_data(map = "world", region = "UK") # changed map to "world"
  plot <- ggplot()
  addMap <- plot + geom_polygon(data = UK, aes(x = long, y = lat, group = group))
  addRaceCourses <- addMap + geom_point(data=courses, aes(x=LONGITUDE, y=LATITUDE), color='red', alpha=0.8)
  addCoordinates <- addRaceCourses + coord_map()
  addLabs <- addCoordinates + labs(x="Longitud", y="Latitud")
  addTheme <- addLabs + theme_minimal()
  
  return(addTheme)
}

plotResults <- function(results){
  data <- resultsFilterPlot(results)
  data <- head(data,10)
  plot <- ggplot(data, aes(NAME, ENTRYNAME, size=Victorias))
  addPoints <- plot + geom_count(color = 'red', show.legend = TRUE)
  addLabs <- addPoints + labs(x="Caballo", y="Jockey", size = "Victorias")
  addTheme <- addLabs + theme_minimal()
  addTheme
}