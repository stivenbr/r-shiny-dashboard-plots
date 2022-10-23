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
source("./modules/owners/ownersModule.R");
source("./modules/races/racesModule.R");
source("./modules/raceCourses/raceCoursesModule.R");
source("./modules/results/resultsModule.R");


sidebar <- bs4DashSidebar(
  status="primary",
  skin = "light",
  bs4SidebarUserPanel("Anderson Barbosa", image = "https://freesvg.org/img/horse-white.png"),
  
  bs4SidebarMenu(
    bs4SidebarMenuItem("Dashboard", tabName = "dashboardTab", icon = icon("layer-group")),
    bs4SidebarMenuItem("Horses", tabName = "horsesTab", icon = icon("horse-head"), selected = TRUE),
    bs4SidebarMenuItem("Jockeys", tabName = "jockeysTab", icon = icon("user-large")),
    bs4SidebarMenuItem("Owners", tabName = "ownersTab", icon = icon("newspaper")),
    bs4SidebarMenuItem("Races", tabName = "racesTab", icon = icon("flag-checkered")),
    bs4SidebarMenuItem("RaceCourses", tabName = "raceCoursesTab", icon = icon("xmarks-lines")),
    bs4SidebarMenuItem("Results", tabName = "resultsTab", icon = icon("person-chalkboard"))    
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
  horsesModuleServer("horses", importData("horses"))
  jockeysModuleServer("jockeys", importData("jockeys"))
  ownersModuleServer("owners", importData("owners"))
  racesModuleServer("races", importData("races"))
  raceCoursesModuleServer("raceCourses", importData("racecourses"))
  resultsModuleServer("results", importData("results"))
}

# Run the application 
shinyApp(ui = ui, server = server)
