#First we need to load the required packages
library(tidyverse)
library(glue)
library(rentrez)

### Basic Terms 

entrez_dbs() #This gives us the available databases that we can search through

entrez_db_searchable(db = "pubmed") #Gives us search terms []

entrez_db_links(db = "pubmed") #See different cross references between databases

entrez_link(dbfrom = "pubmed", term = 

entrez_db_summary("pubmed") #see a summary of the entire database of interest

entrez_db_summary(db = "nuccore") #nuccore and nucleotide are interchangable

entrez_search(db = "pubmed", 
              term = "western diamondback") #building a basic search

entrez_search(db = "pubmed", 
              term = "western diamondback[TITL]") #adding key terms

entrez_search(db ="pubmed", 
              term = "poison dart frog[TITL] OR
              Dendrobatidae[TITL] AND 2010:2020[PDAT]") #using boolean to specify searches


pdfs <- entrez_search(db ="pubmed", 
                      term = "poison dart frog[TITL] OR
              Dendrobatidae[TITL] AND 2010:2020[PDAT]", retmax = 40)

pdfs

poison_dart <-entrez_fetch(db = "pubmed",
                           id = pdfs,
                           web_history = NULL,
                           rettype = "fasta")








              
              
              
              
