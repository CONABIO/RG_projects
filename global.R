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

tablaRG <- read_csv("database/2022-03-23_CNRG_allCols.csv", col_names = T) %>% 
    clean_names()

tablaRG1 <- tablaRG %>% 
    select(proyecto, latitud, longitud, estatus_ecologico, tipo_agroecosistema, genero, 
           epiteto_especifico, epiteto_especifico_otro) %>% 
    mutate(long = longitud) %>% 
    mutate(lat = latitud) %>% 
    select(-c(longitud, latitud)) %>% 
    drop_na("lat") %>% 
    drop_na("long") %>% 
    mutate(RatingCol = as.character(genero)) %>% 
    mutate(epiteto_especifico = if_else(epiteto_especifico == "otra", "", epiteto_especifico)) %>% 
    replace_na(., list(epiteto_especifico_otro = "")) %>% 
    unite(epiteto_especifico, epiteto_especifico_otro, col = "epiteto_especifico", sep = "") %>% 
    mutate(especie1 = genero) %>% 
    mutate(especie2 = epiteto_especifico) %>% 
    unite(especie1, especie2, col = "especie", sep = " ")
   # filter(lat > 0) %>% 
   # filter(long < 0)

#TablaZ1 <- TablaZ1 %>% 
#    mutate(RatingCol = case_when(RatingCol == "Capsicum" ~ "#41ae76",
#                                 RatingCol == "Cucurbita" ~ "#00441b",
#                                 RatingCol == "Gossypium" ~ "#0868ac",
#                                 RatingCol == "Persea" ~ "#4d004b",
#                                 RatingCol == "Phaseolus" ~ "#7f0000",
#                                 RatingCol == "Physalis" ~ "#67001f",
#                                 RatingCol == "Solanum" ~ "#081d58",
#                                 RatingCol == "Tripsacum" ~ "#8c6bb1",
#                                 RatingCol == "Vanilla" ~ "#67000d",
#                                 RatingCol == "Zea" ~ "#99d8c9",
#    ))  %>% 
#    filter(lat > 0) %>% 
#    filter(long < 0)

#TablaZ <- read_csv("database/_DBfinal_Darwin_ID.csv", col_names = T) %>% 
#    clean_names()
#
#TablaZ1 <- TablaZ %>% 
#    rename(especie = "binomial") %>% 
#    rename(lat = "dec_lat") %>% 
#    rename(long = "dec_long") %>% 
#    rename(subespecie = "subspecies") %>% 
#    mutate(genero = especie) %>% 
#    separate(genero, into = c("genero", "especie11"), sep = " ") %>% 
#    select("id_darwin", "genero", "especie", "subespecie","lat", "long", "source","year", 
#           "compiler") %>% 
#    drop_na("lat") %>% 
#    drop_na("long") %>% 
#    mutate(RatingCol = as.character(genero))
#    

#TablaZ2 <- TablaZ1 %>% 
#    select(genero) %>% 
#    mutate(genero = as.factor(genero)) %>% 
#    mutate(val = 1) %>% 
#    group_by(genero) %>% 
#    summarise_all(sum)

#Lat_negativa <- TablaZ1 %>% 
#    filter(lat < 0)
#
#writexl::write_xlsx(Lat_negativa , path = "database/lat_negativa.xlsx")
#
#Long_positiva <- TablaZ1 %>% 
#    filter(long > 0)
#
#writexl::write_xlsx(Long_positiva , path = "database/Long_positiva.xlsx")



