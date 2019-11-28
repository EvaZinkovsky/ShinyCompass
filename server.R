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
library(shinyBS)
 
# Define server logic required to draw a histogram
function(input, output, session) {
  
  rv <- reactiveValues(saved_queries = saved_queries)
  
  querystatus <- eventReactive(input$save, {
    list(program_directors = input$PLident,
         group_leaders = input$GLident,
         team_leaders = input$TLident)
  })
  
  output$querystatus <- renderText({
    text <- querystatus()
    pl <- paste("Program Leaders: ", text$program_directors)
    gl <- paste("Group Leaders: ", text$group_leaders)
    tl <- paste("Team Leaders: ", text$team_leaders)
    HTML(paste(pl, gl, tl, sep = '<br/>'))
  })
  
  observeEvent(input$butsave, {
    toggleModal(session, "savemodal", toggle = "close")
    # browser()
    if(length(rv$saved_queries[[1]]) > 1) {
      rv$saved_queries[length(rv$saved_queries) + 1] <- list(
        list(
          name = input$queryname, query = querystatus()
        )
      )
    } else {
      rv$saved_queries <- list(
        list(
          name = input$queryname, query = querystatus()
        )
      )
    }
    jsonlite::write_json(rv$saved_queries, "saved-queries.json")
  })
  
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

