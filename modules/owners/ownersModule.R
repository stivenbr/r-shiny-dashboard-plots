ownersModuleUI <- function(id){
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
    h1("Propietarios"),
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

ownersModuleServer <- function(id, owners){
  moduleServer(id, function(input, output, session) {
    # -----------------------------------------------
    # Functions
    # -----------------------------------------------
    source("./modules/owners/ownersService.R")
    
    # -----------------------------------------------
    # Reactive
    # -----------------------------------------------
    # Values
    values <- reactiveValues(owners = tableColumns(owners));
    
    # -----------------------------------------------
    # Output
    # -----------------------------------------------
    # Table
    output$table <- renderDataTable({
      getDataTable(values$owners)
    })

  })
}