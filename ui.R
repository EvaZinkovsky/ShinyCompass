library(shiny)
library(shinyBS)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Summary of Compass Trips"),
  
  #create a panel to input Program Director
  selectizeInput("PLident",
                 "Enter Program Director ident", 
                 unique(CompassColumns$Endorser.Name),
                 multiple = TRUE),
  
  #create a panel to input Group Leaders
  selectizeInput("GLident",
                 "Enter Group Leader ident",
                 unique(c(CompassColumns$Line.Manager.Name, CompassColumns$Endorser.Name)),
                 multiple = TRUE),
  
  
  #create a panel to input Program Director
  selectizeInput("TLident",
                "Enter Team Leader ident",
                unique(c(CompassColumns$Line.Manager.Name, CompassColumns$Endorser.Name)),
                multiple = TRUE),
  
  actionButton("save", "Save query"),
  
  actionButton("load", "Load saved query"),
  
  actionButton("submit", "Submit All"),
  
  actionButton("clear", "Clear query"),
  
  bsModal("savemodal", "Save query", "save", size = "large",
          HTML("<strong>The query you are saving has the following structure:</strong>"),
          HTML("<br/>"),
          htmlOutput("querystatus"),
          HTML("<br/>"),
          textInput("queryname", "Please give the query a name"),
          actionButton("butsave", "Save"),
          actionButton("butcancelsave", "Cancel")
  ),
  
  bsModal("loadmodal", "Load a saved query", "load", size = "large",
          uiOutput("loadquery"),
          htmlOutput("loaded_query"),
          actionButton("butload", "Load"),
          actionButton("butcancelload", "Cancel")
  ),
  
  
  
  tableOutput("CompassTable")
  )

