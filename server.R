library(shiny)
library(shinyjs)
library(tercen)
library(dplyr)
library(tidyr)

############################################
#### This part should not be modified
getCtx <- function(session) {
  # retreive url query parameters provided by tercen
  query <- parseQueryString(session$clientData$url_search)
  token <- query[["token"]]
  taskId <- query[["taskId"]]
  
  # create a Tercen context object using the token
  ctx <- tercenCtx(taskId = taskId, authToken = token)
  return(ctx)
}
####
############################################

server <- shinyServer(function(input, output, session) {
  dataInput <- reactive({
    getValues(session)
  })
  
  mode = reactive({ 
    getMode(session)
  })
  
  msgReactive = reactiveValues(msg = "")
  
  observe({
    resultTable = reactive({
      fn = parse(text = input$expr) %>%
        eval()
      dataInput() %>% 
        group_by(.ri, .ci) %>%
        dplyr::summarise(result = fn(.y)) %>%
        ungroup()
    })
    
    output$input.data = renderTable({
      m <- mode()
      if (!is.null(m) && m == 'run'){
        shinyjs::enable("done")
      }
      dataInput() %>%
        select(.ri, .ci, .y) %>%
        arrange(.ri, .ci)
    })
    output$result = renderTable({
      resultTable() %>%
        arrange(.ri, .ci)
    })
    
    output$mode = renderText({
      mode()
    })
    
    output$msg = renderText({
      msgReactive$msg
    })
    
    observeEvent(input$done, {
      shinyjs::disable("done")
      
      tryCatch({
        ctx  <- getCtx(session)
        resultTable() %>%
          as.data.frame() %>%
          ctx$addNamespace() %>%
          ctx$save()
        msgReactive$msg = "Done"
        
      }, error = function(e) {
        msgReactive$msg = paste0("Failed : ", toString(e))
        print(paste0("Failed : ", toString(e)))
      })
    })
  })
})

getValues <- function(session){
  ctx <- getCtx(session)
  df = ctx %>% 
    select(.y, .ri, .ci)
  return(df)
}

getMode <- function(session){
  query <- parseQueryString(session$clientData$url_search)
  return(query[["mode"]])
}



