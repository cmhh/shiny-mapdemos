shinyUI(
  tagList(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    fluidPage(
    
      titlePanel("I'm a map!"),
      
      sidebarLayout(
        sidebarPanel(
          width = 3,
          selectInput("var", "Select variable:", choices = c("v1", "v2")),
          selectInput("ta", "Territorial Authority:", 
                      choices = ta_choices, selectize = FALSE)
        ),
    
        mainPanel(
          width = 9,
          div(
            id = "map-container",
            tags$img(src = "spinner.gif", id = "loading-spinner"),
            leafletOutput("map"))
      )
    )
  )
))

