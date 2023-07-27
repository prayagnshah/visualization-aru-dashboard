library(shiny)
library(tidyverse)
library(dplyr)
library(leaflet)
library(highcharter)





ui <- bootstrapPage(
  
  tags$head(
    tags$link(href = "https://fonts.googleapis.com/css?family=Oswald", rel = "stylesheet"),
    tags$style(type = "text/css", "html, body {width:100%;height:100%; font-family: Oswald, sans-serif;}"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.contentWindow.min.js",
                type="text/javascript")
  ),
  
  leafletOutput("map", width = "100%", height = "100%"),
  
  absolutePanel(
    top = 10, right = 10, style = "z-index:500; text-align: right;",
    tags$h2("Welcome to ARU Data Visualization App")
  ),
  
  absolutePanel(
    top = 80, left = 20, draggable = TRUE, width = "20%", style = "z-index:500; min-width: 10px",
    textInput("geocode", "Type any location name", placeholder = "in Nova Scotia"),
    actionButton("go", "Find Species!", class = "btn-primary"),
    br(),
    highchartOutput("chart", height = "750px")
  )
  
)

# , width = "1400px"

## Javascript credit goes to https://github.com/PaulC91/crime-watch