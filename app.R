library(bs4Dash)
library(dplyr)
library(DT)
library(plotly)
library(ggplot2)
library(thematic)
library(reshape2)
library(stringr)
 
# Data
source("./helpers/globalService.R");
source("./helpers/importData.R");

# Modules
source("./modules/horses/horsesModule.R");
source("./modules/jockeys/jockeysModule.R");
source("./modules/trainers/trainersModule.R");
source("./modules/owners/ownersModule.R");
source("./modules/races/racesModule.R");
source("./modules/raceCourses/raceCoursesModule.R");
source("./modules/results/resultsModule.R");


sidebar <- bs4DashSidebar(
  status="primary",
  skin = "light",
  bs4SidebarUserPanel("Anderson, Bautista, David, Jorge", image = "https://freesvg.org/img/horse-white.png"),
  
  bs4SidebarMenu(
    bs4SidebarMenuItem("Dashboard", tabName = "dashboardTab", icon = icon("layer-group")),
    bs4SidebarMenuItem("Caballos", tabName = "horsesTab", icon = icon("horse-head")),
    bs4SidebarMenuItem("Jockeys", tabName = "jockeysTab", icon = icon("user-large")),
    bs4SidebarMenuItem("Entrenadores", tabName = "trainersTab", icon = icon("person-chalkboard")),
    bs4SidebarMenuItem("Propietarios", tabName = "ownersTab", icon = icon("newspaper"), selected = TRUE),
    bs4SidebarMenuItem("Carreras", tabName = "racesTab", icon = icon("flag-checkered")),
    bs4SidebarMenuItem("Trazados", tabName = "raceCoursesTab", icon = icon("xmarks-lines")),
    bs4SidebarMenuItem("Resultados", tabName = "resultsTab", icon = icon("person-chalkboard"))    
  )
)

body <- bs4DashBody(
  bs4TabItems(
    # Dashboard
    bs4TabItem(
      tabName = "dashboardTab",
      h1("HOLA!")
    ),
    
    # horses Tab
    bs4TabItem(
      tabName = "horsesTab",
      horsesModuleUI("horses")
    ),
    
    # Jockeys Tab
    bs4TabItem(
      tabName = "jockeysTab",
      jockeysModuleUI("jockeys")
    ),
    
    # Trainers Tab
    bs4TabItem(
      tabName = "trainersTab",
      trainersModuleUI("trainers")
    ),
    
    # Owners Tab
    bs4TabItem(
      tabName = "ownersTab",
      ownersModuleUI("owners")
    ),
    
    # Races Tab
    bs4TabItem(
      tabName = "racesTab",
      racesModuleUI("races")
    ),
    
    # Race Courses Tab
    bs4TabItem(
      tabName = "raceCoursesTab",
      raceCoursesModuleUI("raceCourses")
    ),
    
    # Trainers Tab
    bs4TabItem(
      tabName = "resultsTab",
      resultsModuleUI("results")
    )
  )
)

header <- dashboardHeader(
  title = dashboardBrand(
    title = "Grupo TFM",
    color = "primary",
    href = "https://github.com/stivenbr/r-shiny-dashboard-plots",
    image = "https://comunidadbioinfo.github.io/cdsb2021_workflows/img/shiny_1.png",
    opacity = 0.8
  ),
  fixed = TRUE
)

ui <- bs4DashPage(
  fullscreen = TRUE,
  scrollToTop = TRUE,
  header = header,
  sidebar = sidebar,
  body = body,
  
  
  controlbar = bs4DashControlbar(
    skin = "light"
  ),
  footer = bs4DashFooter()
)

server <- function(input, output, session) {
  horses <- importData("horses")
  jockeys <- importData("jockeys")
  trainers <- importData("trainers")
  owners <- importData("owners")
  races <- importData("races")
  raceCourses <- importData("racecourses")
  results <- importData("results")
  
  horsesModuleServer("horses", horses)
  jockeysModuleServer("jockeys", jockeys)
  trainersModuleServer("trainers", trainers)
  ownersModuleServer("owners", owners)
  racesModuleServer("races", races)
  raceCoursesModuleServer("raceCourses", raceCourses)
  resultsModuleServer("results", results)
}

# Run the application 
shinyApp(ui = ui, server = server)
