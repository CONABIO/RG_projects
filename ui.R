library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinydashboard)
#library(shinydashboardPlus)
library(shinythemes)
library(leaflet)
library(tidyverse)
library(rpivotTable)

shinyUI(navbarPage(
    title = "Proyectos RG",


        tabPanel('Mapa',
                 
                 shinyUI(fluidPage(
                    fluidRow(
                        # bootstrapPage( title =  NULL,
                        tags$style(type = "text/css", "#mymap1 {height: calc(90vh) !important;}"),
                        leafletOutput('mymap1', width = "100%", height = "95%"),
                        absolutePanel(
                            top = 90,
                            right = 30,
                            draggable = T,
                            width = "13%",
                            selectizeGroupUI(
                                id = "my_filters",
                                params = list(
                                    genero = list(inputId = "genero", title = "Genero:"),
                                    especie = list(inputId = "proyecto", title = "Proyecto:"),
                                    especie = list(inputId = "estatus_ecologico", title = "Estatus ecológico:")
                                    #    Estado = list(inputId = "Estado", title = "Estado:")
                                ),
                                inline = FALSE,
                                #     btn_label = "Reiniciar la visualización"
                            ),
                            awesomeRadio(
                                inputId = "color_dot",
                                label = "Colores", 
                                choices = c("Proyecto", "Género"),
                                selected = "Proyecto",
                                inline = TRUE, 
                                status = "danger"
                            ),
                        ),
                        #)
                    )
                 ))
        ),
    
   
        tabPanel('Tabla Dinámica',
                 # Define UI for slider demo application
                 shinyUI(
                     
                     fluidPage(
                         #Application title
                         
                         titlePanel("Información General"),
                         h4("En la",tags$a(href = "https://es.wikipedia.org/wiki/Tabla_din%C3%A1mica", "Tabla dinámica") , "selecciona y arrastra el elemento que deseas ver en columna y en renglón"),
                         h4("Selecciona tabla o gráfica para ver y analizar tus datos"),
                         
                         
                         mainPanel(
                             
                             rpivotTableOutput("Ceratti3")
                             
                             #fluidRow(
                             #   column(9, 
                             #          h4("Observaciones"),
                             #          rpivotTableOutput("Ceratti3")
                             #        
                             #   ))
                             
                             
                             , width = 8)
                         
                     )
                 )
        )
    
   
    
        
))
