library(shiny)

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
  
  
  actionButton("submit", "Submit All"),
  
  tableOutput("CompassTable")
  )

