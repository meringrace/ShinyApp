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

# Load the cuts data.
data <- read.csv("carcass_calculator_data.csv")
carcass_data<-read.csv("/users/vincentmd/desktop/data science/midterm/carcass_calculator_data.csv")


water_constant<-6.355078 #water constant gallons per cow
co2_constant<-102.959#(thousand lbs / per 1 animal )
land_constant<-77#(acres / per 1 animal)


server <- function(input, output, session) {
  
  # Change the select input accordingly
  observe({
    x <- input$part
    
    if(x == "Brisket" || x == "Flank") {
      choice = x
    } else if (x == "Shank") {
      choice = "Shanks"
    } else {
      choice = data %>% filter(part == x) %>% select(cut)
    }
    
    # Set the label and select items
    updateSelectInput(session, "CutInParts",
                      label = paste("Select from", x),
                      choices = choice
    )
  })
  
  # Put the image of differnet cuts.
  output$cutImage <- renderImage({
    
    filename <- normalizePath(file.path(paste("www/", input$part, '.PNG', sep='')))
    
    list(src = filename,
         contentType = "image/png",
         width = 500,
         height = 400)
    
  }, deleteFile = FALSE)  
  
  # Calculate the nutrient value
  observe({
    nutrient <- data %>% 
      filter(cut == input$CutInParts) %>%
      select(protein, cal)
    
    # Put the value of protein.
    output$proteinBox <- renderValueBox({
      valueBox(
        paste(nutrient$protein * as.numeric(input$weight) / 1000, "kg"), "Protein",
        icon = icon("dna"), color = "aqua")
    })
    
    # Put the value of cal.
    output$colBox <- renderValueBox({
      valueBox(
        paste(nutrient$cal * as.numeric(input$weight) / 1000, "kCal"), "Calories",
        icon = icon("hotjar") , color = "maroon")
    })
  })
  
  
  observe({
    summary_table<-carcass_data%>%
      mutate(cows_used=ceiling(input$weight/total_weight))%>%
      mutate(Co2_emission=round(cows_used*co2_constant,2))%>%
      mutate(Water_usage=round(cows_used*water_constant,2))%>%
      mutate(Land_usage=round(cows_used*land_constant,2))%>%
      select(cut,cows_used,Co2_emission,Water_usage,Land_usage)%>%
      filter(cut %in% input$cut)
   
    
    #Summary table of all variables
    output$table<-renderTable(summary_table,
                              caption = "Environmental Impact Summary",
                              caption.placement = getOption("xtable.caption.placement", "top"), 
                              caption.width = getOption("xtable.caption.width", NULL))
    
    
    #Plot of water use
    output$wateruse<-renderPlotly(
      ggplot(summary_table,aes(x=cut, y=Water_usage))+
        geom_line(aes(group=1))+
        geom_area(aes(group=1), fill="pink")+
        theme_minimal()+
        labs(title="Water usage per selected cut", x="Type of cut", y="Water usage (gallons)")+
        theme(axis.text.x = element_text(angle=60,size=10,face="bold", hjust=1))+
        theme(axis.text.y = element_text(size=10,face="bold", hjust=1))+
        theme(plot.title = element_text(face="bold",size=18,hjust=0.5))+
        theme(axis.title.x=element_text(face="bold.italic", size=10))+
        theme(axis.title.y=element_text(face="bold.italic", size=10))
    )
    
    #plot of overall impact of selection
    
    output$fulldata<-renderPlotly(
      ggplot(data=summary_table, aes(x=cut, y=Co2_emission,color=Land_usage,size=cows_used))+
        geom_point()+
        theme_minimal()+
        labs(title="Overall Environmental Impact", x="Type of cut", y="CO2 emission(1000 lbs)")+
        theme(axis.text.x = element_text(angle=60,size=10,face="bold", hjust=1))+
        theme(axis.text.y = element_text(size=10,face="bold", hjust=1))+
        theme(axis.title.x=element_text(face="bold.italic", size=10))+
        theme(axis.title.y=element_text(face="bold.italic", size=10))+
        theme(plot.title = element_text(face="bold",size=18,hjust=0.5))+
        scale_color_gradient(low="blue",high="red", space ="Lab" )
        
      
    )
    #number of cows 
    output$cownumber<-renderPlotly(
      
      ggplot(summary_table,aes(x=input$cut,y=cows_used))+
        geom_bar(stat = "identity",fill="purple")+
        theme_minimal()+
        labs(title="Number of cows used per selected cut", x="Type of cut", y="Number of cows")+
        theme(axis.text.x = element_text(angle=60,size=10,face="bold", hjust=1))+
        theme(axis.text.y = element_text(size=10,face="bold", hjust=1))+
        theme(plot.title = element_text(face="bold",size=18,hjust=0.5))+
        theme(axis.title.x=element_text(face="bold.italic", size=10))+
        theme(axis.title.y=element_text(face="bold.italic", size=10))
    )
    
    #Plot of water use
    output$land<-renderPlotly(
      ggplot(summary_table,aes(x=cut, y=Land_usage))+
        geom_bar(stat = "identity", fill="orange")+
        theme_minimal()+
        labs(title="Land usage per selected cut", x="Type of cut", y=Water_usage ("gallons"))+
        theme(axis.text.x = element_text(angle=60,size=10,face="bold", hjust=1))+
        theme(axis.text.y = element_text(size=10,face="bold", hjust=1))+
        theme(plot.title = element_text(face="bold",size=18,hjust=0.5))+
        theme(axis.title.x=element_text(face="bold.italic", size=10))+
        theme(axis.title.y=element_text(face="bold.italic", size=10))
    )
    #Plot of Land use
    output$land<-renderPlotly(
      ggplot(summary_table,aes(x=cut, y=Land_usage))+
        geom_bar(stat = "identity", fill="orange")+
        theme_minimal()+
        labs(title="Land usage per selected cut", x="Type of cut", y="Land usage (acres)")+
        theme(axis.text.x = element_text(angle=60,size=10,face="bold", hjust=1))+
        theme(axis.text.y = element_text(size=10,face="bold", hjust=1))+
        theme(plot.title = element_text(face="bold",size=18,hjust=0.5))+
        theme(axis.title.x=element_text(face="bold.italic", size=10))+
        theme(axis.title.y=element_text(face="bold.italic", size=10))
    )
    #Plot of Carbon use
    output$carbon<-renderPlotly(
      ggplot(summary_table,aes(x=cut, y=Co2_emission))+
        geom_bar(stat = "identity", fill="dark green")+
        theme_minimal()+
        labs(title="Carbon Emission per selected cut", x="Type of cut", y="Carbon emission (1000lbs)")+
        theme(axis.text.x = element_text(angle=60,size=10,face="bold", hjust=1))+
        theme(axis.text.y = element_text(size=10,face="bold", hjust=1))+
        theme(plot.title = element_text(face="bold",size=18,hjust=0.5))+
        theme(axis.title.x=element_text(face="bold.italic", size=10))+
        theme(axis.title.y=element_text(face="bold.italic", size=10))
    )
  })
}
