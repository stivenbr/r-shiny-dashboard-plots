
horsesModuleUI <- function(id){
  ns <- NS(id)
  
  # Table UI
  informacionUI <- tagList(
    # table-form-filer
    fluidRow(
      column(
        width = 2,
        textInput(ns("name"), "Nombre")
      ),
      column(
        width = 2,
        selectInput(ns("sex"), "Sexo", choices = c())
      ),
      column(
        width = 2,
        selectInput(ns("age"), "EDAD", choices = c())
      ),
      column(
        width = 2,
        selectInput(ns("ratingawt"), "PuntosAWT", choices = c())
      ),
      column(
        width = 2,
        textInput(ns("trainerName"), "Entrenador")
      )
    ),
    fluidRow(
      column(
        width = 12,
        actionButton(ns("search"), "Search", status = "success", icon = icon("search"), class="btn-block")
      )
    ),
    hr(),
    dataTableOutput(ns("table"))
  )
  
  # Plot UI
  ratingUI <- tagList(
    fluidRow(
      column(
        width = 3,
        selectInput(ns("type"), "Tipo diagrama", choices = c("Tabla" = "grid", "Agrupado" = "group", "Separado" = "separated")),
      ),
      column(
        width = 3,
        conditionalPanel(
          ns = ns,
          condition = "input.type == 'separated'",
          selectInput(ns("rating"), "Rating", choices = c())  
        )
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
        selected = "rating",
        tabPanel(
          "Información",
          value = "information",
          informacionUI
        ),
        tabPanel(
          "Clasificación",
          value = "rating",
          ratingUI
        )
      )
    )
    
  )
}

horsesModuleServer <- function(id, horses){
  moduleServer(id, function(input, output, session) {
    # -----------------------------------------------
    # Functions
    # -----------------------------------------------
    source("./modules/horses/horsesService.R");
    
    # -----------------------------------------------
    # Variables
    # -----------------------------------------------
    dataRatingPlot <- getDataRatingForPlot(horses);
    
    # -----------------------------------------------
    # Update Filters
    # -----------------------------------------------
    updateSelectInput(session, "sex", choices = c("TODOS", unique(horses$SEX)))
    updateSelectInput(session, "age", choices = c("TODOS", sort(unique(horses$AGE))))
    updateSelectInput(session, "ratingawt", choices = c("TODOS", sort(unique(horses$RATINGAWT))))
    updateSelectInput(session, "rating", choices = getColumnsNamesOfRatings(horses))
    
    # -----------------------------------------------
    # Reactive
    # -----------------------------------------------
    # Values
    values <- reactiveValues(horses = tableColumns(horses));
    
    # -----------------------------------------------
    # Events
    # -----------------------------------------------
    observeEvent(input$search, {
      data <- horses;
      data <- tableFilter(data, input$name, input$sex, input$age, input$ratingawt, input$trainerName)
      data <- tableColumns(data)
      values$horses <- data
    })
    
    # -----------------------------------------------
    # Output
    # -----------------------------------------------
    # Table
    output$table <- renderDataTable({
      getDataTable(values$horses)
    })
    
    # Plot
    output$plot <- renderPlotly({
      if(input$rating == "") return();
      
      type <- input$type
      rating <- input$rating
      
      plot <- switch (input$type,
        "grid" = {
          plot <- ggplot(dataRatingPlot, aes(x=AGE2021, y=value))
          plot <- plot + facet_wrap(~variable)
          plot
        },
        "group" = {
          plot <- ggplot(dataRatingPlot, aes(x=AGE2021, y=value, colour=variable))
          plot
        },
        "separated" = {
          data <- dataRatingPlot %>% dplyr::filter(variable == input$rating)
          plot <- ggplot(data, aes(x=AGE2021, y=value))
          plot
        }
      )
      
      plot <- plot + 
        geom_point() + 
        geom_line() + 
        labs(x = "Edad", y = "Valor") +
        theme_minimal()
      
      return(plot);
    })
    
  })
}