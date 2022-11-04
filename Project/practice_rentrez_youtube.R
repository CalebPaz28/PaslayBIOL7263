

#Practice with rentrez (https://www.youtube.com/watch?v=3-7yfdh2eDE)
#Using publication data to determine the number of publications


#Load rentrez
library(rentrez)
#load tidyverse
library(tidyverse)
#load ggplot2
library(ggplot2)

API (application programming interface) is a way for computer programs to communicate. 

Rentrez gives us access the the URL for NCBI and Pubmed databases. 

entrez_dbs() #gives us a view of availible databases that we can interact with 

entrez_db_summary(db = "pubmed") #Provides quick summary of the database. Number of submissions and date last updated.

entrez_db_summary(db = "nuccore") 

entrez_db_summary(db = "taxonomy")


entrez_db_searchable(db = "pubmed") #provides us with key terms we can use in search for specific topics. 


