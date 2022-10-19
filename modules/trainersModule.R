trainersModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("trainersTab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("trainersTab 2 !")
      )
    )
  )
}

trainersModuleServer <- function(id){
  moduleServer(id, function(input, output, session) {
    
  })
}