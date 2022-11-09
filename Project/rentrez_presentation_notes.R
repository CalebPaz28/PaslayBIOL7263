snippet ## ---------------------------
##
## Script name: Rentrez:Entrez Walkthrough 
##
## Purpose of script: To present information related to rentrez package
##
## Author: Caleb Paslay
##
## Date Created: 2022-09-22
##
##
## ---------------------------
##
## Notes: Presentation Notes 
##  
##
## ---------------------------

## install the packages needed: 


install.packages("rentrez") #first we will need to install the package


## Load the packages


library(rentrez) # now we can load rentrez
library(tidyverse) 
library(ggplot2)
library(glue) #use this for plotting


## Basic terms that we will use most often


entrez_dbs() #this option gives us a list of the NCBI databases


entrez_db_summary() #we can specify for a summary of a particular database


entrez_db_searchable("pubmed") # set of search terms that can be used for a given database


entrez_db_links() #set of databases that contain linked records (not discussing today)


entrez_search() #build searches for whatever it is we are seeking


entrez_summary() #obtain brief summaries of search parameters


entrez_fetch() #obtain "full" information and export files for use in other programs


## Searching databases (start here)

entrez_dbs()

entrez_db_summary("nuccore")

amv_search <- entrez_search(db = "nuccore", term = "alfalfa mosaic virus") #object returned acts like a list
amv_search
amv_search$ids #ids are very important and are used to extract or provide further details about the search


# Narrow the search using entrez_db_searchable terms 
entrez_db_searchable(db = "pubmed")
entrez_db_searchable(db = "nuccore")

amv_search_1 <- entrez_search(db = "nuccore", term = "alfalfa mosaic virus[ORGN]")
amv_search_1

# Further narrowing the search using boolean operators 
amv_search_2 <- entrez_search(db = "nuccore", term = "alfalfa mosaic virus[ORGN] AND 2016[PDAT]")
amv_search_2 <- entrez_search(db = "nuccore", term = "alfalfa mosaic virus[ORGN] AND 2016/01/01:2018/01/01[PDAT]")
amv_search_2

# Use of retmax
amv_search_3 <- entrez_search(db = "nuccore", term = "alfalfa mosaic virus", retmax = 40)
amv_search_3$ids


# Interestingly we can use the search function to establish trends in a given field (I did not come up with this)
search_year <- function(year, term){
  query <- paste(term, "AND (", year, "[PDAT])") 
  entrez_search(db="pubmed", term=query, retmax=0)$count
}

year <- 1960:2020
papers <- sapply(year, search_year, term="alflfa mosaic virus", USE.NAMES = FALSE)
plot(year, papers, type='b', main="AMV Publications from 1960 to 2020")



# entrez_summary() less and brief information entrez_fetch() all or most of the information

entrez_summary(db = "nuccore", id = 2323502180)

brca_1 <- entrez_search(db = "pubmed", term = "brca gene[TITL] AND human", retmax = 74)
brca_1


entrez_summary(db = "nuccore",id = amv_search$ids)

entrez_summary(db = "pubmed", id = brca_1$ids)

## A vector for more than 1 ID can be established and a list of summary records will be given back. 

amv_multi_summ <- entrez_summary(db = "nuccore", id = amv_search$ids)
brca1_multi_summ <- entrez_summary(db = "pubmed", id = brca_1$ids)

#rentrez also has a helpful function, extract_from_esummary()
#This takes one or more elements from every summary record in one of the lists

extract_from_esummary(esummaries, elements, simplify = TRUE)

extract_from_esummary(amv_multi_summ, "title", simplify = TRUE) #extracting one element

multi_extract <- extract_from_esummary(amv_multi_summ, c("createdate", "statistics", "title", "organism", "trait_set"), simplify = TRUE)
View(multi_extract) # multiple elements extracted

multi_brca_extract <- extract_from_esummary(brca1_multi_summ, c("title", "pubtype", "pubdate", "authors"), simplify = TRUE)
View(multi_brca_extract)


#Summary records are useful, but may not include all relevant information
# We can use entrez_fetch() to get a complete representation
# We will also use rettype to specify formatting




