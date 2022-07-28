
library(httr)
library(jsonlite)
library(tidyverse)
library(janitor)

set_config(config(ssl_verifypeer = 0L))



##   my_query <- "{
##     registros(pagination:{limit:100}){
##       EstatusEcologico
##       proyecto_id
##       proyecto(search:{field:proyecto_id}){
##         NombreProyecto
##       }
##       sitio(search:{field:sitio_id}){
##         Latitud
##       Longitud
##       }
##       taxon(search:{field:taxon_id}){
##         taxon_id
##         Genero
##         EpitetoEspecifico
##         EpitetoSubespecie
##         EpitetoVariedad
##         EpitetoForma
##         EpitetoRaza
##         EpitetoCultivar
##       }
##     }
##   }
##   "
##   
##   ###  url del servidor GraphiQL 
##   url1 <- c('https://colectas-siagro.conabio.gob.mx/api/graphql')
##   ##
##   ##
##   result <- POST(url = url1, body = list(query = my_query))
##   result$status_code
#   jsonResult <- content(result, as = "text") 
#   
#   readableResult <- fromJSON(jsonResult, 
#                              flatten = T)
#   
#   data <- as.data.frame(readableResult$data[1]) 
#   


get_from_graphQL <- function(query, url){
    
    require(httr)
    require(jsonlite)
    require(tidyverse)
    require(janitor)
    
     
    ### This function queries a GraphiQL API and outpus the data into a single data.frame 
    
    ## Arguments
    # query: a graphQL query. It should work if you try it in graphiQL server. Must be a character string.
    # url = url of the server to query. Must be a character string.
    
    ## Needed libraries:
    # library(httr)
    # library(jsonlite)
    # library(dplyr)
    # library(stringr)
    
    ### Function
    
    result <- POST(url, body = list(query=query), encode=c("json"))
    
    ##  query the server
    ##result <- POST(url, body = list(query = query))
    
    ## check server response
    satus_code <- result$status_code
    
    if (satus_code != 200) {
        print(paste0("Oh, oh: status code ", satus_code, ". Check your query and that the server is working"))
    }
    
    else{
        
        # get data from query result
        jsonResult <- content(result, as = "text") 
        
        # check if data downloaded without errors
        # graphiQL will send an error if there is a problem with the query and the data was not dowloaded properly, even if the connection status was 200. 
        ### FIX this when != TRUE because result is na
        errors <- grepl("errors*{10}", jsonResult)
        if (errors == TRUE) {
            print("Sorry :(, your data downloaded with errors, check your query and API server for details")
        } 
        else{ 
            # transform to json
            readableResult <- fromJSON(jsonResult, 
                                       flatten = T) # this TRUE is to combine the different lists into a single data frame (because data comming from different models is nested in lists)
            
            # get data
            data <- as.data.frame(readableResult$data[1]) 
            
            # rename colnames to original variable names
            x <- str_match(colnames(data), "\\w*$")[,1] # matches word characters (ie not the ".") at the end of the string
            colnames(data) <- x # assing new colnames
            return(data)
        }
    }
}


#data <- get_from_graphQL(query = my_query, 
#                         url = "https://siagro.conabio.gob.mx/colectas_api")
#
#head(data)
