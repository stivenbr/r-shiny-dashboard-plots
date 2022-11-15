raceCoursesModuleUI <- function(id){
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
    h1("Trazados"),
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

raceCoursesModuleServer <- function(id, raceCourses){
  moduleServer(id, function(input, output, session) {
    # -----------------------------------------------
    # Functions
    # -----------------------------------------------
    source("./modules/raceCourses/raceCoursesService.R")

    # -----------------------------------------------
    # Reactive
    # -----------------------------------------------
    # Values
    values <- reactiveValues(raceCourses = tableColumns(raceCourses));
    
    # -----------------------------------------------
    # Output
    # -----------------------------------------------
    # Table
    output$table <- renderDataTable({
      getDataTable(values$raceCourses)
    })
  })
}