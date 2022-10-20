raceCoursesModuleUI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        h1("raceCoursesTab !")
      ),
      bs4Card(
        width = 6,
        title = "Biostats",
        status = "orange",
        h1("raceCoursesTab 2 !")
      )
    )
  )
}

raceCoursesModuleServer <- function(id, raceCourses){
  moduleServer(id, function(input, output, session) {
    
  })
}