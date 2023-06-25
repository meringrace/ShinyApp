#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(plotly)

# Load the data
data <- read.csv("carcass_calculator_data.csv")

# Head Part
dbHeader <- dashboardHeader(title = "Beef", titleWidth = 170)

# Link the icon to the website
dbHeader$children[[2]]$children <-  tags$a(href='https://www.happyvalleymeat.com/',
                                           tags$img(src='HVMC_logo_green.png',
                                                    height='40', width='140'))


# Side Bar
dbSider <- dashboardSidebar(
  width = 170,
  
  # Tabs for chosen
  sidebarMenu(
    
    # Tab for cuts
    menuItem("Cuts", tabName = "cuts", icon = icon("dashboard")),
    
    # Tab for environment impact
    menuItem("Environment", tabName = "env", icon = icon("envira")),
    
    # Raw data
    menuItem("Raw Data", tabName = "raw", icon = icon("table")),
    
    # Scource code
    menuItem("Source code", icon = icon("github"), 
             href = "https://github.com/hongyaozhu98/midterm")

  )
)


# Main Body
dbMain <- dashboardBody(
  
  tabItems(

##################################################  

    # Tab for cuts
    tabItem(
      tabName = "cuts",
      h2("Cuts of Meat"),
      fluidRow(
        
        column(
          
          width = 6,
          
          # Select cuts and input weight.
          box(status = "success",
              selectInput(
            inputId =  "cuts.part", 
            label = "Select Parts",
            choices = c("Other", "Brisket", "Chuck", "Flank", "Loin", "Plate", "Rib", "Round", "Shank"), 
            selected = 1),
            width = 3
          ),
          
          box(status = "success",
              selectInput(
            inputId =  "cuts.CutInParts", 
            label = h3(""),
            choices = "", 
            selected = 1),
            width = 5
          ),
          
          box(status = "success",
              textInput(
            inputId = "cuts.weight",
            label = "Pounds of Beef",
            value = "1000"),
            width = 4
          ),

          # Show the nutrient content.
          valueBoxOutput("proteinBox", width = 6),
          
          valueBoxOutput("colBox", width = 6)
          
        ),
        
        # Show the cuts
        column(
          width = 6,
          imageOutput("cutImage", height = 100)
        ) 
      )
    ),

##################################################  
    # Tab for environment impact

    tabItem(tabName = "env",
      h2("Enviroment Impact of Different Cuts"),
      fluidRow(
        column(
          width = 4,
          
          # Select cuts and input weight.
          box(status = "success",
              selectInput(
                inputId =  "env.CutInParts", 
                label = h3("Select your cuts"),
                choices = data$cut, 
                selected = data$cut,
                multiple = T),
              width = 12
          ),
          
          box(status = "success",
              textInput(
                inputId = "env.weight",
                label = "Pounds of Beef",
                value = "1000"),
              width = 12
          )
        ),
        column(
          width = 8,
          
          # Out put the plots.
          tabBox(
            title = "Environment Impact",
            id = "env.tab",height = "700px", width = 12,
            tabPanel("Total", plotlyOutput("total")),
            tabPanel("Number", "number"),
            tabPanel("Water", "water"),
            tabPanel("CO2", "CO2"),
            tabPanel("Land", "land")
          )
        )
      )
      
     
    ),

##################################################  

    # Tab for raw data
    tabItem(tabName = "raw",
      h2("All Collected Data"),
      tableOutput("raw")
    )
  
  )
  
)



dashboardPage(
  
  skin = "green",
  dbHeader, 
  dbSider,
  dbMain
  
)
