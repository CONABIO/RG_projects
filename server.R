library(shiny)
library(shinyWidgets)
library(leaflet)
library(RColorBrewer)
library(tidyverse)
library(shinyjs)
library(scales)
library(rpivotTable)

#setwd()
#options(rsconnect.check.certificate = FALSE)
#rsconnect::deployApp() 

#source(file = "global.R")

# Define server logic for slider examples
shinyServer(function(input, output, session) {
   
points <- callModule(
  module = selectizeGroupServer,
  id = "my_filters",
  data = tablaRG3,
  vars = c("genero", "proyecto", "estatus_ecologico")
)

  points1 <- reactive({
      
      
      
    columna1 <- c(ifelse(input$color_dot == "Proyecto",
                                     names(points())[9], names(points())[8])) %>% 
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
      
    #  color11 <- ifelse(input$color_dot = FALSE, Goldberg %>% select(colores_genero),
    #                    Goldberg %>% select(colores_proyecto))
      
    #  uno1 <- as.vector(Goldberg$colores_proyecto)
    #  dos2 <- as.vector(Goldberg$colores_genero)
      
      
      
    #  TT <- paste(Goldberg$Raza_primaria)
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
                                      # "Num. colecta:",Goldberg$numero_colecta_observacion,"<br/>",
                                       "Proyecto:",Goldberg$proyecto,"<br/>",
                                       "Especie:",Goldberg$especie,"<br/>",
                                       "Status ecológico:",Goldberg$estatus_ecologico,"<br/>",
                                      "Latitud:",Goldberg$lat,"<br/>",
                                      "Longitud:",Goldberg$long)) %>%
        
        addProviderTiles("CartoDB.Positron")
      
    }) 
  
  #Para hacer un PivotTable
  
  output$Ceratti3 <- renderRpivotTable({
    
    tablaRG4 <- tablaRG3 %>% 
      select(proyecto,
             estatus_ecologico,
             genero,
             epiteto_especifico,
             especie)
    
    rpivotTable(tablaRG4)
  })
  
})