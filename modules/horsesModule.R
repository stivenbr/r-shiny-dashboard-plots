
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
  
  # Plot UI
  plotUI <- tagList(
    fluidRow(
      column(
        width = 3,
        selectInput(ns("rating"), "Rating", choices = c("AWT", "CHASE", "FLAT", "HURDLE"))
      )
    ),
    hr(),
    plotlyOutput(ns("plot"))
  )
  
  
  tagList(
    
    fluidRow(
      valueBox(
        value = 150,
        subtitle = "New orders",
        color = "primary",
        icon = icon("cart-shopping"),
        href = "#"
      ),
      valueBox(
        elevation = 4,
        value = "53%",
        subtitle = "New orders",
        color = "danger",
        icon = icon("gears")
      ),
      valueBox(
        value = "44",
        subtitle = "User Registrations",
        color = "warning",
        icon = icon("sliders")
      ),
      valueBox(
        value = "53%",
        subtitle = "Bounce rate",
        color = "success",
        icon = icon("database")
      )
    ),
    
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
          plotUI
        )
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
        class = 'cell-border stripe',
        options = list(
          dom = 'ti',
          
          # FixedColumns
          scrollX = TRUE,
          fixedColumns = list(leftColumns = 2),
          
          # Scroller
          deferRender = TRUE,
          scrollY = 400,
          scroller = TRUE
        ),
        extensions = c('FixedColumns', 'Scroller')
      )
    })
    
    # Plot
    output$plot <- renderPlotly({
      plot <- filterPlot()
      plot
    })
    
  })
}


