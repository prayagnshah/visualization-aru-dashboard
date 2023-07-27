library(shiny)
library(tidyverse)
library(dplyr)
library(leaflet)
library(highcharter)
library(shinyWidgets)
library(lubridate)




# Reading the wildtrax data

species <- read.csv("data/ARU-Final-Data.csv")

server <- function(input, output, session) {
  
  # Assigning filtered_species as a reactive object
  
  filtered_species <- reactiveValues(filtered_species = species, find_clicked = FALSE)

 # Showing the progress message when it filters the data
  
  observeEvent(input$go, {
    
    withProgress(
      message = "Filtering the species data...",
      value = 1/5, {
        
        tryCatch({
        
        
          filtered_data <- filter(species, grepl(input$geocode, location)) %>%
            arrange(taxon_order)
          
        
        incProgress(1/5)
        
        filtered_species$filtered_species <- filtered_data
        
        incProgress(1/5)
        
      },
      
      error = function(e) {
        # Handle any error that might occur during the data filtering process
        
        showNotification(
          paste("An error occured while filtering the species data:", e$message), 
          type = "error"
        )
      
      }
      )
      }
    )
  })
  


  # Showing the marked species on the map on the basis of filtered species

  output$map <- renderLeaflet({


    filtered_data <- filtered_species$filtered_species  %>%
      filter(!is.na(Longitude) & !is.na(Latitude))       # Using filter to avoid NA values in future

    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(-63.5, 45.32, zoom = 8) %>%
      addMarkers(data = filtered_data, lat = filtered_data$Latitude, lng = filtered_data$Longitude,
                 popup = filtered_data$location)
    
    
  })


  # Showing bar charts once the Find species is clicked

  output$chart <- renderHighchart({
    
    # if (filtered_species$find_clicked) {
    if(!is.null(filtered_species$filtered_species)) {
      
      
      species$recordingDate <- ymd_hms(species$recordingDate)
      
      # Data wrangling to mark the species if they are in probable or possible format 
      species_occurence <- filtered_species$filtered_species %>%
        group_by(species_common_name, location) %>%
        arrange(recordingDate) %>%
        mutate(week = ymd_hms(recordingDate)) %>%
        summarize(first_detection = min(week),
                  last_detection = max(week)) %>%
        mutate(difference = as.numeric(last_detection - first_detection),
               occurrence_label = ifelse(difference > 7, "Probable", "Possible"))
      

      
      
 
       # Data Wrangling
      species_count <- filtered_species$filtered_species %>%
        group_by(species_class, species_common_name, taxon_order) %>%
        summarize(count = n(), .groups = "drop") %>%
      arrange(is.na(taxon_order), taxon_order, species_common_name)
      
      # Adding occurrence label into the dataframe species_count
      species_count <- species_count %>%
        left_join(species_occurence, by = "species_common_name")
     


      # Adding high chart and its characteristics
      hchart(species_count, type = "bar", hcaes(x = species_common_name,y = count)) %>%
        hc_colors("SteelBlue") %>%
        hc_legend(layout = "horizontal", align = "right", verticalAlign = "top") %>%
        hc_title(text = paste("Species name by", input$geocode)) %>%
        hc_xAxis(title = list(text = "Species"), gridLineWidth = 0, minorGridLineWidth = 0) %>%
        hc_yAxis(title = list(text = "Total Count"), gridLineWidth = 0, minorGridLineWidth = 0) %>%
        hc_tooltip(pointFormat = "Count: <b>{point.y}</b><br>Occurrence: <b>{point.occurrence_label}</b>") %>%
        hc_plotOptions(series = list(cursor = "default")) %>%
        hc_add_theme(hc_theme_smpl()) %>%
        hc_plotOptions(
          series = list(
            cursor = "default", 
            dataLabels = list(
              enabled = TRUE,
              format = '{point.occurrence_label}',
              color = 'black',
              align = 'top',
              style = list(fontSize = '9px')
            )
          )
        ) %>%   # Introducing plot options to show the label written on the top of bar
        hc_chart(backgroundColor = "transparent")

    }
    

      })

}


