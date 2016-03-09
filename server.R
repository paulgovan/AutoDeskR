
library(shiny)
library(leaflet)

data <- data.frame(lat = 30.6190, long = -96.3359)

shinyServer(function(input, output, session) {

  output$map <- renderLeaflet({
    leaflet(data) %>%
      addTiles() %>%
      addCircleMarkers() 
  })
})
