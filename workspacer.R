library(shiny)
library(tercen)
library(tidyverse)


source("ui.R")
source("server.R")

options("tercen.workflowId"= "0844af3c27bc4f1fd354e37fa800aa8e")
options("tercen.stepId"= "22b28d8e-8019-4ddd-8ffa-a9251352c2dd")

runApp(shinyApp(ui, server))  
