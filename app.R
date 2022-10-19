library(shiny)

# Modules
source("modules/horsesModule.R");
source("modules/jockeysModule.R");
source("modules/ownersModule.R");
source("modules/racesModule.R");
source("modules/raceCoursesModule.R");
source("modules/trainersModule.R");
source("helpers/funDataSets.R");

sidebar <- bs4DashSidebar(
  status="orange",
  bs4SidebarUserPanel("Grupo TFM", image = "https://freesvg.org/img/horse-white.png"),
  
  bs4SidebarMenu(
    bs4SidebarMenuItem("Horses", tabName = "horsesTab", icon = icon("horse-head"), selected = TRUE),
    bs4SidebarMenuItem("Jockeys", tabName = "jockeysTab", icon = icon("user-large")),
    bs4SidebarMenuItem("Owners", tabName = "ownersTab", icon = icon("newspaper")),
    bs4SidebarMenuItem("Races", tabName = "racesTab", icon = icon("flag-checkered")),
    bs4SidebarMenuItem("RaceCourses", tabName = "raceCoursesTab", icon = icon("xmarks-lines")),
    bs4SidebarMenuItem("Trainers", tabName = "trainersTab", icon = icon("person-chalkboard"))    
  )
)

body <- bs4DashBody(
  bs4TabItems(
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
      tabName = "trainersTab",
      trainersModuleUI("trainers")
    )
  )
)

ui <- bs4DashPage(
  dashboardHeader("Winning Horse"),
  sidebar = sidebar,
  body = body
)

server <- function(input, output, session) {
  horsesModuleServer("horses", cargaDataSet("horses"))
  jockeysModuleServer("jockeys")
  ownersModuleServer("owners")
  racesModuleServer("races")
  raceCoursesModuleServer("raceCourses")
  trainersModuleServer("trainers")
}

# Run the application 
shinyApp(ui = ui, server = server)
