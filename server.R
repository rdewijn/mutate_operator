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
        select(.ri, .ci, .y)
    })
    output$result = renderTable({
      resultTable()
    })
    
    observeEvent(input$done, {
      shinyjs::disable("done")
      ctx  <- getCtx(session)
      resultTable() %>%
        as.data.frame() %>%
        ctx$addNamespace() %>%
        ctx$save()
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



