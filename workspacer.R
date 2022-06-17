library(shiny)
library(tercen)
library(tidyverse)


source("ui.R")
source("server.R")

options("tercen.workflowId"= "8f17d834dda49eba43ac822ed600aa7b")
options("tercen.stepId"= "b0a24196-b518-4388-afed-1cf2e23af99c")

runApp(shinyApp(ui, server))  
