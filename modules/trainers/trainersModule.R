trainersModuleUI <- function(id){
  ns <- NS(id)
  
  # --------------------------
  # TAB Información
  # --------------------------
  informationTAB <- tagList(
    hr(),
    dataTableOutput(ns("table"))
  )
  
  # --------------------------
  # UI
  # --------------------------
  tagList(
    h1("Entrenadores"),
    fluidRow(
      bs4TabCard(
        width = 12,
        type = "tabs",
        status = "primary",
        solidHeader = TRUE,
        maximizable = TRUE,
        selected = "information",
        tabPanel(
          "Información",
          value = "information",
          informationTAB
        )
      )
    )
  )
}

trainersModuleServer <- function(id, trainers){
  moduleServer(id, function(input, output, session) {
    # -----------------------------------------------
    # Functions
    # -----------------------------------------------
    source("./modules/trainers/trainersService.R")
    
    # -----------------------------------------------
    # Reactive
    # -----------------------------------------------
    # Values
    values <- reactiveValues(trainers = tableColumns(trainers));
    
    # -----------------------------------------------
    # Output
    # -----------------------------------------------
    # Table
    output$table <- renderDataTable({
      getDataTable(values$trainers)
    })
    
  })
}