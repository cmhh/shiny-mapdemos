library(shiny)

shinyUI(
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      tags$script(src = "alert.js")
    ),
    fluidPage(
      absolutePanel(top = 0, left = 0, right = 0, bottom = 0,
                    id = "map-container",
                    tags$img(src = "spinner.gif", id = "loading-spinner"),
                    leafletOutput("map", height = "100%")),
      absolutePanel(top = 10, right = 10, draggable = TRUE,
                    style = "max-width: 100px;",
                    wellPanel(selectInput("var", "Select variable:",
                                          choices = c("v1", "v2"))))
    )
  )
)

