ownersModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("ownersTab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("ownersTab 2 !")
      )
    )
  )
}

ownersModuleServer <- function(id){
  moduleServer(id, function(input, output, session) {
    
  })
}