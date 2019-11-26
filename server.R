#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
 
# Define server logic required to draw a histogram
function(input, output) {
  leaders <- eventReactive(input$submit, {
   
 
   
     
    CompassColumns %>% 
      filter(Endorser.Name %in% input$PLident | Line.Manager.Name %in% c(input$PLident, input$GLident, input$TLident))%>%
      select(-Endorser.Name, -Line.Manager.Name)%>%
      mutate(Blank1 = " ",Blank2 = " " )%>%
      rename(" " = Traveller.Name,WBS = Cost.Object,Departure = Departure.Date,Return = Return.Date,"   " = Blank1,"    " = Segment.Start.Date,"     " = Segment.End.Date,"                 " = Blank2, "Base Contact" = Base.Contacts )%>%
      arrange(Departure) %>% 
      mutate(Departure = as.character(Departure), Return = as.character(Return))
      

    
    
  })
  
  output$CompassTable <- renderTable({
    leaders()
    
  })
}