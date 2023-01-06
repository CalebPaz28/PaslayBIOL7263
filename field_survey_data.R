
library(readr)
library(tidyverse)
field_collection_data <- read_csv("Catalog (Revision 3).csv")

field_collection_data %>% 
  na.omit() %>% 
  rownames()

#removing the 4th row of the dataframe  (NA's)
field_collection_data_1 <- subset(field_collection_data[-7,])
field_collection_data_1
View(field_collection_data_1)
