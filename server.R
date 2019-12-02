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
    # browser()
    list(program_directors = input$PLident,
         group_leaders = input$GLident,
         team_leaders = input$TLident)
  })
  
  output$querystatus <- renderText(HTML(print_query_status(querystatus())))
  #   browser()
  #   text <- querystatus()
  #   pl <- paste("Program Leaders: ", text$program_directors)
  #   gl <- paste("Group Leaders: ", text$group_leaders)
  #   tl <- paste("Team Leaders: ", text$team_leaders)
  #   HTML(paste(pl, gl, tl, sep = '<br/>'))
  # })
  
  observeEvent(input$butsave, {
    toggleModal(session, "savemodal", toggle = "close")
    # browser()
    if(length(rv$saved_queries) > 0) {
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
    dput(rv$saved_queries, "saved-queries.txt")
    updateTextInput(session, "queryname", "Please give the query a name", value = "")
  })
  
  observeEvent(input$butcancelsave, {
    toggleModal(session, "savemodal", toggle = "close")
  })
  
  observeEvent(input$butload, {
    toggleModal(session, "loadmodal", toggle = "close")
    query <- loaded_query()
    # browser()
    updateSelectizeInput(session, 
                         "PLident",
                         "Enter Program Director ident", 
                         unique(CompassColumns$Endorser.Name),
                         selected = query$query$program_directors)
    
    updateSelectizeInput(session,
                         "GLident",
                         "Enter Group Leader ident",
                         unique(c(CompassColumns$Line.Manager.Name, CompassColumns$Endorser.Name)),
                         selected = query$query$group_leaders)
    
    
    #create a panel to input Program Director
    updateSelectizeInput(session,
                         "TLident",
                         "Enter Team Leader ident",
                         unique(c(CompassColumns$Line.Manager.Name, CompassColumns$Endorser.Name)),
                         selected = query$query$team_leaders)
  })
  
  observeEvent(input$butcancelload, {
    toggleModal(session, "loadmodal", toggle = "close")
  })
  
  output$loadquery <- renderUI({
    queries <- unlist(lapply(rv$saved_queries, function(x) x$name))
    selectizeInput("saved_query_name", 
                   "Choose a query to load", 
                   queries
    )
  })
  
  observeEvent(input$clear, {
    updateSelectizeInput(session,
                         "PLident",
                         "Enter Program Director ident", 
                         unique(CompassColumns$Endorser.Name),
                         selected = "")
    
    updateSelectizeInput(session,
                         "GLident",
                         "Enter Group Leader ident",
                         unique(c(CompassColumns$Line.Manager.Name, CompassColumns$Endorser.Name)),
                         selected = "")
    
    
    #create a panel to input Program Director
    updateSelectizeInput(session,
                         "TLident",
                         "Enter Team Leader ident",
                         unique(c(CompassColumns$Line.Manager.Name, CompassColumns$Endorser.Name)),
                         selected = "")
  })
  loaded_query <- reactive({
    input$saved_query_name
    # browser()
    if(!is.null(input$saved_query_name)) {
      # browser()
      query_names <- unlist(lapply(rv$saved_queries, function(x) x$name))
      query <- rv$saved_queries[[match(input$saved_query_name, query_names)]]
      return(query)
    }
  })
  
  output$loaded_query <- renderText({
    # browser()
    print_query(loaded_query())
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

