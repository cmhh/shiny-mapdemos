shinyServer(function(input, output, session) {
  output$tamap <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      fitBounds(166.41630, -47.28706, 178.55037, -34.39263) %>%
        addEasyButton(easyButton(
          icon="fa-arrows-alt", title="Reset zoom",
          onClick=JS("function(btn, map){ map.fitBounds([[-47.28706, 166.41630],
                     [-34.39263, 178.55037]]); }")))
    m
  })
  
  tadata <- reactive({
    ta %>% filter(ta2013_v1_00 == input$ta)
  })
  
  audata1 <- reactive({
    tmp <- mbhg %>% 
      filter(ta2013_v1_00 == input$ta) %>%
      select(au2013_v1_00) %>% 
      unique
    
    au %>%
      inner_join(tmp, by = "au2013_v1_00")
  })
  
  audata2 <- reactive({
    audata1() %>%
      mutate(value = !!rlang::sym(input$var))
  })
  
  observeEvent(input$ta, {
    assign('tadata', tadata(), envir = .GlobalEnv)
    leafletProxy("tamap") %>%
      clearGroup("TA")
    
    bb <- structure(st_bbox(tadata()), names = NULL)
    
    leafletProxy("tamap") %>%
      fitBounds(bb[1], bb[2], bb[3], bb[4]) %>%
      addPolygons(data = tadata(),
                  color = "#000000", weight = 2, opacity = 1, fillOpacity = 0,
                  group = "TA")
  })
  
  observe({
    req(audata2())
    
    cat("hey!!!\n")
    
    leafletProxy("tamap") %>%
      clearGroup("AU")
    
    pal <- colorNumeric(
      palette = "Blues",
      domain = audata2()$value)
    
    lbl <- sprintf("<b>%s</b><br>%.2f%%",
                   audata2()$au2013_v1_00_name, audata2()$value)
    
    leafletProxy("tamap") %>%
      addPolygons(data = audata2(),
                  color = "#000000",
                  opacity = 1,
                  weight = 1,
                  fillColor = ~pal(value),
                  fillOpacity = 1,
                  label = lapply(lbl, HTML),
                  group = "AU") 
  })
})
