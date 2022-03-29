library(shiny)
library(shinyjs)
library(shinyWidgets)
#library(grid)
#library(vcd)
#library(plyr)
library(tidyverse)
library(readxl)
library(xlsx)
library(leaflet)
library(janitor)
#library(wesanderson)
#library(ghibli)
library(randomcoloR)
library(httr)
library(jsonlite)
library(rpivotTable)


set_config(config(ssl_verifypeer = 0L))

#Here is the function that design Alice
source(file = "source_graphQL.R", local = T)

url1 <- c("https://siagro.conabio.gob.mx/colectas_api")

#This are the steps to tak all the data in Zendro from the section:
# Desgargar los datos cuando necesitamos hacer paginación from the Rmarkdown

no_records <- get_from_graphQL(query = "{countRegistros}", url=url1)

# change to vector, we don't need a df
no_records <- no_records[1,1]
no_records

# Define desired number of records and limit. Number of pages and offset will be estimated based on the number of records to download
no_records <- no_records # this was estimated above with a query to count the total number of records, but you can also manually change it to a custom desired number
my_limit <- 1000 # max 1000
no_pages <- ceiling(no_records/my_limit)

## Define offseet.
# You can use the following loop:
# to calculate offset automatically basedon 
# on the number of pages needed.
my_offset <- 0 # start in 0. Leave like this
for(i in 1:no_pages) {
    # loop to
    my_offset <- c(my_offset, my_limit * i)
}

# Or you can define the offset manually 
# uncommenting the following line
# and commenting the loop above:
# offeset<-c(#manually define your vector) 

## create obtjet where to store downloaded data. Leave empity
data <- character()

##
## Loop to download the data from GraphQL using pagination
## 

for(i in c(1:length(my_offset))){
    
    # Define pagination
    pagination <- paste0("limit:", my_limit, ", offset:", my_offset[i])
    
    # Define query looping through desired pagination:
    my_query <- paste0("{
  registros(pagination:{", pagination, "}){
    EstatusEcologico
    proyecto_id
    proyecto(search:{field:proyecto_id}){
      NombreProyecto
    }
    sitio(search:{field:sitio_id}){
      Latitud
    Longitud}
    taxon(search:{field:taxon_id}){
      taxon_id
      Genero
      EpitetoEspecifico
      EpitetoSubespecie
      EpitetoVariedad
      EpitetoForma
      EpitetoRaza
      EpitetoCultivar
      ObservacionesTaxonomicas
    }
  }
}")
    
    # Get data and add it to the already created df
    data <- rbind(data, get_from_graphQL(query = my_query, url = url1))
    
    #end of loop
}

tablaRG <- data %>% 
    clean_names()
##  write.xlsx2(data, file = "database/datosAPI.xlsx", col.names = T)
##  
##  tablaRG <- readxl::read_xlsx(path = "database/datosAPI.xlsx", col_names = T) %>% 
##      clean_names()

tablaRG1 <- tablaRG %>%
    select(proyecto_id,
        latitud,
        longitud,
        estatus_ecologico,
        genero,
        epiteto_especifico,
    ) %>%
    rename(proyecto = proyecto_id) %>% 
    rename(long = longitud) %>%
    rename(lat = latitud) %>%
    #select(-c(longitud, latitud)) %>%
    drop_na("lat") %>%
    drop_na("long") %>%
    drop_na("proyecto") %>% 
   # mutate(genero = if_else(genero == "otra", "", genero)) %>%
   # replace_na(., list(genero_otro = "")) %>%
    mutate(especie1 = genero) %>%
    mutate(especie2 = epiteto_especifico) %>%
    unite(especie1, especie2, col = "especie", sep = " ")

   # filter(lat > 0) %>% 
   # filter(long < 0)

#Colores para los géneros
genero2 <- tablaRG1 %>% 
    select(genero) %>% 
    distinct()

TT <- nrow(genero2)
paletteTT <- distinctColorPalette(TT)

genero2 <- genero2 %>% 
    mutate(colores_genero = paletteTT)


tablaRG2 <- tablaRG1 %>% 
    left_join(genero2, by = "genero")


# colores para proyectos

#Colores para los géneros
proyecto2 <- tablaRG1 %>% 
    select(proyecto) %>% 
    distinct()

TT1 <- nrow(proyecto2)
paletteTT1 <- distinctColorPalette(TT1)

proyecto2 <- proyecto2 %>% 
    mutate(colores_proyecto = paletteTT1)


tablaRG3 <- tablaRG2 %>% 
    left_join(proyecto2, by = "proyecto") %>% 
    drop_na(lat) %>% 
    drop_na(long)


