#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)

# Load the cuts data.
data <- read.csv("carcass_calculator_data.csv")

# Constants
water.rate <- 6.355078 #(million gallons/ per 1 animal )
co2.emision <- 102.959 #(thousand lbs / per 1 animal )
land.use <- 77 #(acres / per 1 animal)

server <- function(input, output, session) {
  
############################################################# 
# Cuts tab.  
  
  # Change the select input accordingly
  observe({
    x <- input$cuts.part
    
    if(x == "Brisket" || x == "Flank") {
      choice = x
    } else if (x == "Shank") {
      choice = "Shanks"
    } else {
      choice = data %>% filter(part == x) %>% select(cut)
    }
    
    # Set the label and select items
    updateSelectInput(session, "cuts.CutInParts",
                      label = paste("Select from", x),
                      choices = choice
    )
  })
  
  # Put the image of differnet cuts.
  output$cutImage <- renderImage({
    
    filename <- normalizePath(file.path(paste("www/", input$cuts.part, '.PNG', sep='')))
    
    list(src = filename,
         contentType = "image/png",
         width = 500,
         height = 400)
    
  }, deleteFile = FALSE)  
  
  # Calculate the nutrient value
  observe({
    nutrient <- data %>% 
      filter(cut == input$cuts.CutInParts) %>%
      select(protein, cal)
    
    # Put the value of protein.
    output$proteinBox <- renderValueBox({
      valueBox(
        paste(nutrient$protein * as.numeric(input$cuts.weight) / 1000, "kg"), "Protein",
        icon = icon("dna"), color = "aqua")
    })
    
    # Put the value of cal.
    output$colBox <- renderValueBox({
      valueBox(
        paste(nutrient$cal * as.numeric(input$cuts.weight) / 1000, "kCal"), "Calories",
        icon = icon("hotjar") , color = "maroon")
    })
  })
  
#############################################################   
# Env tab
  
  # Plot total impact.
  output$total <- renderPlotly({
    ds <- data %>%
      mutate(number.cows = ceiling(as.numeric(input$env.weight) / total_weight)) %>%
      mutate(water = water.rate * number.cows,
             co2 = co2.emision * number.cows,
             land = land.use * number.cows) %>%
      mutate(text = paste("Cut Name: ", cut,
                          "\nNumber of Cows: ", number.cows,
                          "\nWater Consumption (M Gallons): ", round(water,1),
                          "\nLand Usage (Acres): ", land,
                          "\nCO2 Emmition: ", round(co2, 1), sep="")) %>%
      filter(cut %in% input$env.CutInParts) 
    
      
      # Classic ggplot
      p <- ggplot(data = ds, aes(x=cut, y=co2, size = land, color = water, text= text)) + 
        geom_point(alpha=0.7) +
        scale_size(range = c(1, 19), name="Land Usage (Acres)") +
        scale_color_gradient(low = "#66CCFF", high = "#0000FF") +
        theme_classic() + 
        labs(title = "Total Environment Impact", x = "", y = "CO2 Emmition (Klbs)") +
        coord_flip() 
    
    # turn ggplot interactive with plotly
    total <- ggplotly(p, tooltip="text", height = 600)
      
  })
  
  
############################################################# 
# Raw data tab.
  
  output$raw <- renderTable(data)
  
  
}
