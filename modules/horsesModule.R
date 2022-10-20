
horsesModuleUI <- function(id){
  ns <- NS(id)
  
  # Table UI
  tableUI <- tagList(
    fluidRow(
      column(
        width = 3,
        selectInput(ns("sex"), "Sexo", choices = c())
      ),
      column(
        width = 3,
        selectInput(ns("ratingawt"), "PuntosAWT", choices = c())
      ),
      column(
        width = 3,
        br(),
        actionButton(ns("search"), "Search", status = "success", icon = icon("search"))
      )
    ),
    hr(),
    dataTableOutput(ns("table"))
  )
  
  
  tagList(
    
    fluidRow(
      bs4TabCard(
        width = 12,
        type = "tabs",
        status = "primary",
        solidHeader = TRUE,
        maximizable = TRUE,
        tabPanel(
          "Tabla",
          value = "tabla",
          tableUI
        ),
        tabPanel(
          "Grafica",
          value = "grafica",
          "Pepe 2 !"
        )
      )
    ),
    

    fluidRow(
      bs4Card(
        width = 3,
        title = "Filters",
        status = "orange",
        selectInput(ns("rating"), "Rating", choices = c("AWT", "CHASE", "FLAT", "HURDLE"))
      ),
      bs4Card(
        width = 9,
        title = "Diagrama",
        status = "orange",
        plotlyOutput(ns("plot"))
      )
    )
  )
}

horsesModuleServer <- function(id, horses){
  moduleServer(id, function(input, output, session) {
    # Functions
    tableFilter <- function(data){
      sex <- input$sex;
      if(sex != "ALL"){
        data <- data %>% dplyr::filter(SEX == sex) 
      }
      return(data)
    }
    tableColumns <- function(data){
      data <- data %>% 
        select(NAME, DATEOFBIRTH,SEX, TRAINERNAME, OWNERNAME, RATINGAWT, RATINGCHASE, RATINGFLAT, RATINGHURDLE) %>% 
        rename(Nombre = NAME, Nacimiento = DATEOFBIRTH, Sexo = SEX, Entrenador = TRAINERNAME, Propietario = OWNERNAME, PuntosAWT = RATINGAWT, PuntosCHASE = RATINGCHASE, PuntosFLAT = RATINGFLAT, puntosHURDLE = RATINGHURDLE)
      return(data)
    }
    
    # Update Filters
    updateSelectInput(session, "sex", choices = c("ALL", unique(horses$SEX)))
    updateSelectInput(session, "age", choices = c("ALL", sort(unique(horses$AGE))))
    updateSelectInput(session, "ratingawt", choices = c("ALL", sort(unique(horses$RATINGAWT))))
    
    # Reactive
    values <- reactiveValues(horses = tableColumns(horses));
    
    # Reactive Functions
    filterPlot <- reactive({
      data <- plotHorses(horses, input$rating)
      return(data)
    })
    
    # Events
    observeEvent(input$search, {
      data <- horses;
      data <- tableFilter(data)
      data <- tableColumns(data)
      values$horses <- data
    })
    
    # Table
    output$table <- renderDataTable({
      data = values$horses
      DT::datatable(
        data, 
        options = list(
          orderClasses = TRUE
        )
      )
    })
    
    # Plot
    output$plot <- renderPlotly({
      plot <- filterPlot()
      plot
    })
    
  })
}


