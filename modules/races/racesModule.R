racesModuleUI <- function(id){
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
    h1("Carreras"),
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

racesModuleServer <- function(id, races){
  moduleServer(id, function(input, output, session) {
    # -----------------------------------------------
    # Functions
    # -----------------------------------------------
    source("./modules/races/racesService.R")

    # -----------------------------------------------
    # Reactive
    # -----------------------------------------------
    # Values
    values <- reactiveValues(races = tableColumns(races));
    
    # -----------------------------------------------
    # Output
    # -----------------------------------------------
    # Table
    output$table <- renderDataTable({
      getDataTable(values$races)
    })
  })
}