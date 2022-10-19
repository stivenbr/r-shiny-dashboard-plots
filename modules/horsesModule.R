
horsesModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      bs4Card(
        width = 3,
        title = "Filters",
        status = "orange",
        selectInput(ns("sex"), "Sex", choices = c()),
        selectInput(ns("age"), "Age", choices = c(2:14))
      ),
      bs4Card(
        width = 9,
        title = "Horses",
        status = "orange",
        p("Grafica Aqui")
        # dataTableOutput("tableHorses")
      )
    )
  )
}

horsesModuleServer <- function(id, horses){
  moduleServer(id, function(input, output, session) {
    updateSelectInput(session, "sex", choices = c("ALL", unique(horses$SEX)))
  })
}


