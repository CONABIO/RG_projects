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


#    columna1 <- ifelse(input$color_dot == "Proyecto",
#                       names(points())[9], names(points())[10])
#    
#    TTablaL1 <-  points() %>% 
#        select(all_of(columna1))
    

    
  points1 <- reactive({
    
    columna1 <- c(ifelse(input$color_dot == "Proyecto",
                                     names(points())[10], names(points())[9])) %>% 
        as.character()
      
  })
  
  
  #P el mapa en leaflet
  output$mymap1 <- renderLeaflet(
    {
        
        columna1 <- points1()
        
          TTablaL <- points() %>% 
              select(all_of(columna1)) %>%
              as.data.frame()
        
       
      Goldberg <- TTablaL %>%
          as.data.frame() %>% 
          bind_cols(points())
      
      
      names(Goldberg)[1] <- c("colores111")
      
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(Goldberg$long, Goldberg$lat, 
                         weight = 8, radius = 5, stroke = F, fillOpacity = 0.7, 
                         #color = ifelse(input$color_dot, Goldberg$colores_proyecto, Goldberg$colores_genero),
                        color = Goldberg$colores111,
                        # color = "red",
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