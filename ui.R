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
carcass_data<-read.csv("/users/vincentmd/desktop/data science/midterm/carcass_calculator_data.csv")
carcass_data

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
    menuItem("Environment", tabName = "env", icon = icon("bar-chart-o")),
    
    
    
    # Scource code
    menuItem("Source code", icon = icon("github"), 
             href = "https://github.com/hongyaozhu98")

  )
)


# Main Body
dbMain <- dashboardBody(
  
  tabItems(
    
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
            inputId =  "part", 
            label = "Select Parts",
            choices = c("Other", "Brisket", "Chuck", "Flank", "Loin", "Plate", "Rib", "Round", "Shank"), 
            selected = 1),
            width = 3
          ),
          
          box(status = "success",
              selectInput(
            inputId =  "CutInParts", 
            label = h3(""),
            choices = "", 
            selected = 1),
            width = 5
          ),
          
          box(status = "success",
              textInput(
            inputId = "weight",
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
    
    # Tab for environment impact
    tabItem(tabName = "env",
            h2("Enviroment Impact of Different Cuts"),
            fluidPage(
              numericInput("weight","Enter the amount of meat (Lb)", value=0, min=0),
              selectInput("cut","Cuts of meat",carcass_data$cut,selected = 1, multiple = TRUE),
              
              
              mainPanel(
                tableOutput("table"),
                plotlyOutput(outputId="fulldata",width="800px"),
                plotlyOutput(outputId="cownumber", width="700px"),
                plotlyOutput(outputId="wateruse",width="700px"),
                plotlyOutput(outputId="carbon", width="700px"),
                plotlyOutput(outputId="land", width="700px")
              )
            )
  )
)
  
  
)



dashboardPage(
  
  skin = "green",
  dbHeader, 
  dbSider,
  dbMain
  
)
