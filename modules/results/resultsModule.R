resultsModuleUI <- function(id){
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
    h1("Resultados"),
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

resultsModuleServer <- function(id, results){
  moduleServer(id, function(input, output, session) {
    # -----------------------------------------------
    # Functions
    # -----------------------------------------------
    source("./modules/results/resultsService.R")

    # -----------------------------------------------
    # Reactive
    # -----------------------------------------------
    # Values
    values <- reactiveValues(results = tableColumns(results));
    
    # -----------------------------------------------
    # Output
    # -----------------------------------------------
    # Table
    output$table <- renderDataTable({
      getDataTable(values$results)
    })
  })
}