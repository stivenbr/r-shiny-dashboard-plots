racesModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("racesTab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("racesTab 2 !")
      )
    )
  )
}

racesModuleServer <- function(id){
  moduleServer(id, function(input, output, session) {
    
  })
}