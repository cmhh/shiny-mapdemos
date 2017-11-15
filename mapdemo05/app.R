library(shiny)
library(highcharter)
library(dplyr)

regc <- readRDS("data/regc.rds") %>%
  mutate(v1 = rnorm(nrow(.), 6, 2), v2 = rnorm(nrow(.), 60, 10)) 

regcgeojson <- jsonlite::fromJSON("data/regc.json", simplifyVector = FALSE)

maptheme <- function(source = "some place", url = "http://www.someplace.com"){
  p <- c("#FFFFFF", 
         rev(c("#00407D", "#004F9E", "#2B6BAD", "#5489BF", "#80A6CF", "#AAC4DD")))
  stops <- data.frame(q = seq(0, 1, 1/6), c = p, stringsAsFactors = FALSE)
  stops <- list_parse2(stops)

  res <- hc_theme(
    chart = list(
      backgroundColor = "#FFFFFF",
      style = list(
        fontFamily = 'Source Sans Pro'
      )
    ),
    colorAxis = list(
      stops = stops
    ),
    title = list(
      align = "center",
      style = list(
        color = '#000000',
        fontFamily = 'Source Sans Pro',
        fontSize = "11px",
        fontWeight = "bold"
      )
    ),
    subtitle = list(
      align = "center",
      margin = 50,
      style = list(
        color = '#000000',
        fontFamily = 'Source Sans Pro',
        fontSize = "11px",
        paddingBottom = "15px"
      )
    ),
    legend = list(
      itemStyle = list(
        fontFamily = 'Source Sans Pro',
        color = '#3E576F',
        fontWeight = 'normal'
      ),
      itemHoverStyle = list(
        color = 'gray'
      )
    ),
    credits = list(
      enabled = TRUE,
      text = sprintf("Source: %s", source),
      mapText = sprintf("Source: %s", source),
      href = url,
      style = list(
        color = '#000000',
        fontFamily = 'Source Sans Pro',
        fontSize = "11px"
      )
    )
  )

  res
}

ui <- fluidPage(
  titlePanel("Highchart map..."),
  
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectInput("var",
                  "Select variable:",
                  choices = c("v1", "v2"))
    ),
    
    mainPanel(
      width = 10,
      highchartOutput("map")
    )
  )
)

server <- function(input, output, session) {
  
  mapdata <- reactive({
    req(input$var)
    regc %>% 
      select(code, name, !!rlang::sym(input$var)) %>%
      rename(value = !!rlang::sym(input$var)) %>%
      mutate(value = round(value, 1))
  })
  
  output$map <- renderHighchart({
    req(mapdata())
    m <- highchart() %>%
      hc_add_series_map(regcgeojson, mapdata(),
                        name = "rate (%)", value = "value",
                        joinBy = "code") %>%
      hc_mapNavigation(enabled = TRUE)
    
    m <- m %>%
      hc_credits(enabled = TRUE) %>%
      hc_exporting(enabled = TRUE)%>%
    hc_add_theme(maptheme()) 
    
    m
  })
}

shinyApp(ui = ui, server = server)

