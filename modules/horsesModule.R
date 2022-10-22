
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
    # Filter data table by table-form-filer
    tableFilter <- function(data, name, sex, age, ratingawt, trainerName){
      trainerName <- stringr::str_to_lower(trainerName)
      data <- data %>%
        dplyr::filter(
          if(name != "") stringr::str_detect(str_to_lower(NAME), name) else TRUE,
          if(sex != "TODOS") SEX == sex else TRUE,
          if(age != "TODOS") AGE2021 == age else TRUE,
          if(ratingawt != "TODOS") RATINGAWT == ratingawt else TRUE,
          if(trainerName != "") stringr::str_detect(str_to_lower(TRAINERNAME), trainerName) else TRUE
        )
      
      return(data)
    }
    
    # Get name by print columns in view
    tableColumns <- function(data){
      data <- data %>% 
        dplyr::select(NAME, AGE2021, DATEOFBIRTH, SEX, TRAINERNAME, OWNERNAME, RATINGAWT, RATINGCHASE, RATINGFLAT, RATINGHURDLE) %>% 
        dplyr::rename(Nombre = NAME, Edad = AGE2021, Nacimiento = DATEOFBIRTH, Sexo = SEX, Entrenador = TRAINERNAME, Propietario = OWNERNAME, PuntosAWT = RATINGAWT, PuntosCHASE = RATINGCHASE, PuntosFLAT = RATINGFLAT, puntosHURDLE = RATINGHURDLE)
      return(data)
    }
    
    # get names of columns start with by "ratings"
    getNamesOfColumnsRatings <- function(data){
      columns <- colnames(data);
      columnsRating <- columns[startsWith(columns, "RATING")]
      return(columnsRating)
    }
    
    # get data rating for plot
    getDataRatingForPlot <- function(data){
      data <- data %>%
        dplyr::group_by(AGE2021) %>% # group values by age
        dplyr::summarize(across(starts_with("RATING"), ~ round(mean(.x, na.rm=TRUE), 2))) %>% # Filter columns by name and round values
        reshape2::melt(id="AGE2021") %>% # Convert columns to rows by id
        dplyr::filter(!is.na(value))
      
      return(data)
    }
    
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
    updateSelectInput(session, "rating", choices = getNamesOfColumnsRatings(horses))
    
    # Reactive
    values <- reactiveValues(horses = tableColumns(horses));
    
    # Events
    observeEvent(input$search, {
      data <- horses;
      data <- tableFilter(data, input$name, input$sex, input$age, input$ratingawt, input$trainerName)
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