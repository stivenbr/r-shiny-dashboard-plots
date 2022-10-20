resultsModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("resultsTab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("resultsTab 2 !")
      )
    )
  )
}

resultsModuleServer <- function(id, results){
  moduleServer(id, function(input, output, session) {
    
  })
}