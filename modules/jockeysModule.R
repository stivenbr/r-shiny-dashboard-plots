jockeysModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("jockeysTab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("jockeysTab 2 !")
      )
    )
  )
}

jockeysModuleServer <- function(id){
  moduleServer(id, function(input, output, session) {
    
  })
}