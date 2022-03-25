library(shiny)
library(shinyWidgets)
library(leaflet)
library(RColorBrewer)
library(tidyverse)
library(shinyjs)


# Define server logic for slider examples
shinyServer(function(input, output, session) {
   
  
points <- callModule(
  module = selectizeGroupServer,
  id = "my_filters",
  data = tablaRG1,
  vars = c("genero", "proyecto", "estatus_ecologico")
)

  points1 <- reactive({
    
    TTablaL <- points()
  })

  
  #P el mapa en leaflet
  output$mymap1 <- renderLeaflet(
    {
      
     # Parientes2 <- Parientes[Parientes$Tipo %in% input$Tipo,]
     # factpal <- colorFactor(c("red", "orange"), Parientes2$Tipo)
      
      Goldberg <- points1()
      
    #  TT <- paste(Goldberg$Raza_primaria)
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(Goldberg$long, Goldberg$lat, 
                         weight = 8, radius = 4, stroke = F, fillOpacity = 0.7, 
                         #color = Goldberg$RatingCol,  
                         color = "red",  
                         popup = paste(sep = " ",
                                       "Especie:",Goldberg$especie,"<br/>",
                                       "Subespecie:",Goldberg$estatus_ecologico,"<br/>", 
                                       "Fuente:",Goldberg$tipo_agroecosistema)) %>%
        
        
      #  addCircleMarkers(lng = Parientes2$longitude[!is.na(Parientes2$longitude)], 
      #                   lat = Parientes2$latitude[!is.na(Parientes2$latitude)], 
      #                   weight = 3, radius = 3, color = factpal(Parientes2$Tipo), opacity = 0.6,
      #                   popup = paste(sep = " ",
      #                                 "Taxa:",Parientes2$Taxa,"<br/>", 
      #                                 "Estado:",Parientes2$Estado, "<br/>",
      #                                 "Municipio:",Parientes2$Municipio, "<br/>")) %>%
        addProviderTiles("CartoDB.Positron")
      
    }) 
 # observe({
 #   Parientes2 <- Parientes[Parientes$Tipo %in% input$Tipo,]
 #   factpal <- colorFactor(c("red", "orange"), Parientes2$Tipo)
 #   proxy1 <- leafletProxy("mymap1" ) %>%
 #     
 #     addCircleMarkers(lng = Parientes2$longitude[!is.na(Parientes2$longitude)], 
 #                      lat = Parientes2$latitude[!is.na(Parientes2$latitude)], 
 #                      weight = 3, radius = 3, color = factpal(Parientes2$Tipo), opacity = 0.6,
 #                      popup = paste(sep = " ",
 #                                    "Taxa:",Parientes2$Taxa,"<br/>", 
 #                                    "Estado:",Parientes2$Estado, "<br/>",
 #                                    "Municipio:",Parientes2$Municipio, "<br/>"))
 #   
 # })
})