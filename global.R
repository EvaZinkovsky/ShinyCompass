library(tidyverse)
library(readxl)

# the data for all CSIRO travellers within a set time period 
# has been taken from the compass site and saved to the data folder as CompassReport.csv

# CompassReport.csv is assigned to a variable "compass"
#compass <- read.csv("data/CompassReport.csv", stringsAsFactors = FALSE)

compass <- read_excel("CompassReport.xlsx") %>% 
  set_names(make.names(names(.))) %>% 
  mutate(departure = as.character(format(as.Date(Departure.Date), "%d/%m/%Y")),
         return = as.character(format(as.Date(Return.Date), "%d/%m/%Y")))

# select useful rows for the table
#CompassColumns <- select(compass,Traveller.Name,Departure.Date,Return.Date,Cost.Object,Line.Manager.Name,Endorser.Name,Status,Base.Contacts,Country,City,Segment.Start.Date,Segment.End.Date)

#convert data formats so that they can be sorted later on
# CompassColumns$Departure.Date <- as.Date(CompassColumns$Departure.Date, format = "%d/%m/%Y")
# CompassColumns$Return.Date <- as.Date(CompassColumns$Return.Date, format = "%d/%m/%Y")
# CompassColumns$Segment.Start.Date <- as.Date(CompassColumns$Segment.Start.Date, format = "%d/%m/%Y")
# CompassColumns$Segment.End.Date <- as.Date(CompassColumns$Segment.End.Date, format = "%d/%m/%Y")

CompassColumns <- compass

if(!file.exists("saved-queries.json")){
  jsonlite::write_json("", "saved-queries.json")
} 

saved_queries <- jsonlite::read_json("saved-queries.json")

