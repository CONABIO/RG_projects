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
                                     names(points())[11], names(points())[10])) %>% 
        as.character()
      
  #  TTablaL <- points() %>% 
  #      select(all_of(columna1)) %>%
  #      as.data.frame()
##        bind_cols(points())
##    
##    
##  #  tablaRG5 <- TTablaL %>% 
##  #      select(proyecto:especie)
##    
##    #TTablaL1 <-  TTablaL %>% 
##    #    select(all_of(columna1)) %>% 
##    #    bind_cols(tablaRG5)
##    
##    names(TTablaL)[1] <- c("colores111")
    
   # rm(tablaRG5, TTablaL)
  #  color13 <- TTablaL[,ifelse(input$color_dot == "Proyecto", 10, 9)] 
  #  
  #  TTablaL <- TTablaL %>% 
  #      select(proyecto:especie) %>% 
  #      bind_cols(color13)
  #  
  #  names(TTablaL)[9] <- c("colores111")
    
   # rm(color13)
  #  color11 <- ifelse(input$color_dot == "Proyecto", names(TTablaL)[10], names(TTablaL)[9])
  #  
  #  color12 <- TTablaL %>% 
  #      select(all_of(color11)) %>% 
  #      as.vector()
  #  
  #  TTablaL <- TTablaL %>% 
  #      bind_cols(tablaRG5)

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
                                       "Num. colecta:",Goldberg$numero_colecta_observacion,"<br/>",
                                       "Proyecto:",Goldberg$proyecto,"<br/>",
                                       "Especie:",Goldberg$especie,"<br/>",
                                       "Status ecológico:",Goldberg$estatus_ecologico,"<br/>", 
                                       "Agroecosistema:",Goldberg$tipo_agroecosistema)) %>%
        
        addProviderTiles("CartoDB.Positron")
      
    }) 
})