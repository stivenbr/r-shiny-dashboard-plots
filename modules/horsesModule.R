
horsesModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("Horses Tab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("Horses Tab 2 !")
      )
    )
  )
}

horsesModuleServer <- function(id){
  moduleServer(id, function(input, output, session) {
    
  })
}


