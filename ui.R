library(shiny)
library(shinyjs)

ui <- shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  tags$script(HTML('setInterval(function(){ $("#hiddenButton").click(); }, 1000*30);')),
  tags$footer(shinyjs::hidden(actionButton(inputId = "hiddenButton", label = "hidden"))),
  
  titlePanel("Mutate"),
  

  mainPanel(
    textInput("expr", "Enter your transformation expression",value = "function(y) mean(y)"),
    actionButton("done", "Transform data", disabled = TRUE),
    fluidRow(
      column(6, tableOutput("input.data")),
      column(6, tableOutput("result")),
      h3(textOutput("mode")),
      h5(textOutput("msg"))
    )
    
  )
  
))
