htmlTemplate(
  filename  = "www/index.html", document_ = TRUE,
  varselect = selectInput1("var", "Select variable:",
                           choices = c("v1", "v2"),
                           class = "col-sm-6"),
  taselect  = selectInput1("ta", "Territorial Authority:",
                           choices = ta_choices, selectize = FALSE,
                           class = "col-sm-6"),
  themap    = leafletOutput("tamap", height = "600px"))
