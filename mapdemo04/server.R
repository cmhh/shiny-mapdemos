library(shiny)

shinyServer(function(input, output, session) {
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      fitBounds(166.41630, -47.28706, 178.55037, -34.39263) %>%
        addEasyButton(easyButton(
          icon="fa-arrows-alt", title="Reset zoom",
          onClick=JS("function(btn, map){ map.fitBounds([[-47.28706, 166.41630],
                     [-34.39263, 178.55037]]); }"))) %>%
      addPolygons(data = ta,
                  color = "#000000", opacity = 1, weight = 1,
                  fillOpacity = 0)
    
    m
  })
  
  observe({
    req(input$map_shape_click, input$var)
    
    p <- st_point(c(input$map_shape_click$lng, input$map_shape_click$lat))
    i <- sf::st_intersects(p, ta, sparse = FALSE)
    clicked_ta <- ta[i,]
    
    bb <- structure(st_bbox(clicked_ta), names = NULL)
    
    tmp <- mbhg %>% 
      filter(ta2013_v1_00 == data.frame(clicked_ta)$ta2013_v1_00) %>%
      select(au2013_v1_00) %>% 
      unique
    
    mapdata <- au %>%
      inner_join(tmp, by = "au2013_v1_00") %>%
      mutate(value = !!rlang::sym(input$var))
    
    pal <- colorNumeric(
      palette = "Blues",
      domain = mapdata$value)
    
    lbl <- sprintf("<b>%s</b><br>%.2f%%",
                   mapdata$au2013_v1_00_name, mapdata$value)
    
    leafletProxy("map") %>%
      fitBounds(bb[1], bb[2], bb[3], bb[4]) %>%
      clearGroup("AU") %>%
      addPolygons(data = mapdata,
                  color = "#000000",
                  opacity = 1,
                  weight = 1,
                  fillColor = ~pal(value),
                  fillOpacity = 1,
                  label = lapply(lbl, HTML),
                  group = "AU") 
  })
})
