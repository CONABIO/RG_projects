library(shiny)
library(shinyWidgets)
library(leaflet)
library(RColorBrewer)
library(tidyverse)
library(shinyjs)
library(scales)


# Define server logic for slider examples
shinyServer(function(input, output, session) {
   
  
points <- callModule(
  module = selectizeGroupServer,
  id = "my_filters",
  data = tablaRG3,
  vars = c("genero", "proyecto", "estatus_ecologico")
)

  points1 <- reactive({
    
    TTablaL <- points()
  
   # Goldberg <- Goldberg %>% 
   #   bind_cols(color11)
  })

  
  #P el mapa en leaflet
  output$mymap1 <- renderLeaflet(
    {
      
     # Parientes2 <- Parientes[Parientes$Tipo %in% input$Tipo,]
     # factpal <- colorFactor(c("red", "orange"), Parientes2$Tipo)
      
      
      Goldberg <- points1()
      
    #  color11 <- ifelse(input$color_dot = FALSE, Goldberg %>% select(colores_genero),
    #                    Goldberg %>% select(colores_proyecto))
      
      uno1 <- as.vector(Goldberg$colores_proyecto)
      dos2 <- as.vector(Goldberg$colores_genero)
      
      
      
    #  TT <- paste(Goldberg$Raza_primaria)
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(Goldberg$long, Goldberg$lat, 
                         weight = 8, radius = 5, stroke = F, fillOpacity = 0.7, 
                         #color = ifelse(input$color_dot, Goldberg$colores_proyecto, Goldberg$colores_genero),
                         color = ifelse(input$color_dot == "Proyecto", Goldberg[,9], Goldberg[,10]),
                        # fillColor = color,
                         #color = uno1,  
                         popup = paste(sep = " ",
                                       "Proyecto:",Goldberg$proyecto,"<br/>",
                                       "Especie:",Goldberg$especie,"<br/>",
                                       "Status ecológico:",Goldberg$estatus_ecologico,"<br/>", 
                                       "Agroecosistema:",Goldberg$tipo_agroecosistema)) %>%
        
        addProviderTiles("CartoDB.Positron")
      
    }) 
})