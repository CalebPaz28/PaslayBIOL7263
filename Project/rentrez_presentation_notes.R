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


####################################################################################################


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


brca_data <- data.frame(multi_brca_extract)
View(brca_data)

#######################################################################################################

#Summary records are useful, but may not include all relevant information
# We can use entrez_fetch() to get a complete representation
# We will also use rettype to specify formatting

https://www.ncbi.nlm.nih.gov/books/NBK25499/table/chapter4.T._valid_values_of__retmode_and/

  
# example of the arguments used
entrez_fetch(db = "pubmed", id = ..., rettype = "fasta")
  
  

# Nucelotide fetch (rettype is more specific and retmode or more general)

all_amv_search <- entrez_fetch(db = "nuccore", id = amv_search$ids, rettype = "fasta")
class(all_amv_search) 

nchar(all_amv_search) #number of characters

write(all_amv_search, file ="my_amv_transcripts.fasta")


# Pubmed fetch
all_brca_search <- entrez_fetch(db = "pubmed", id = brca_1$ids, rettype = "abstract")
class(all_brca_search)
nchar(all_brca_search)


write(all_brca_search, file = "my_brca_search_abstracts.fasta")


#####################################################################################################


# Plot using ggplot2 to plot two differnt searches 

year <- 1950:2022
alfalfa_search <- glue("alfalfa mosaic virus[TITL]) AND {year}[PDAT]")
tomato_search <- glue("tomato yellow leaf curl virus[TITL] AND {year}[PDAT]")

search_counts <- tibble(year = year,
                        alfalfa_search = alfalfa_search, 
                        tomato_search = tomato_search) %>% 
  mutate(alfalfa = map_dbl(alfalfa_search, ~entrez_search(db="pubmed",
                                                          term = .x)$count),
         tomato = map_dbl(tomato_search, ~entrez_search(db="pubmed",
                                                        term = .x)$count))

search_counts %>% 
  select(year, alfalfa, tomato) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line()+
  geom_smooth()+
  geom_point(color = "grey")+
  theme_bw()


####################################################################################################

year <- 1950:2022
amv_search <- glue("alfalfa mosaic virus[TITL] AND {year}[PDAT]")
all_search <- glue("{year}[PDAT]") #this will include all publications from 1950:2022


search_count_1 <- tibble(year = year, 
                        amv_search = amv_search,
                        all_search = all_search) %>% 
  mutate(AMV = map_dbl(amv_search, ~entrez_search(db ="pubmed",
                                                    term = .x)$count),
         ALL = map_dbl(all_search, ~entrez_search(db ="pubmed", 
                                                  term = .x)$count))


search_count_1 %>% 
  select(year, BCTV, ALL) %>%
  mutate(relative_bctv = BCTV / ALL) %>% 
  ggplot(aes(x =year, 
             y = relative_bctv)) +
  theme_bw()+
  geom_line()


search_count_1 %>% 
  select(year, BCTV, ALL) %>%
  mutate(relative_bctv = 100 * BCTV / ALL) %>% 
  ggplot(aes(x =year, 
             y = relative_bctv)) +
  theme_bw()+
  geom_line()




#########################################################################################################
# All pulications in comparison to a topic of choice

year <- 1950:2022
amv_search <- glue("alfalfa mosaic virus[TITL] AND {year}[PDAT]")
all_virus_search <- glue("viruses AND {year}[PDAT]") #this will include all publications on viruses from 1950:2022


search_count_2 <- tibble(year = year, 
                        amv_search = amv_search,
                        all_virus_search = all_virus_search) %>% 
  mutate(AMV = map_dbl(amv_search, ~entrez_search(db ="pubmed",
                                                    term = .x)$count),
         ALL_virus = map_dbl(all_virus_search, ~entrez_search(db ="pubmed", 
                                                  term = .x)$count))


search_count_2 %>% 
  select(year, AMV, ALL_virus) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value, 
             group = name, 
             color = name)) +
  theme_bw() + 
  geom_line(size = 1)


search_count_2 %>% 
  select(year, AMV, ALL_virus) %>%
  mutate(relative_amv = AMV / ALL_virus * 100) %>% 
  ggplot(aes(x =year, 
             y = relative_amv)) +
  theme_bw()+
  geom_line(size = 1)


#This gives us the relative number of publications of AMV in comparision to ALL virus publications from 1950:2022 

###########################################################################################################

#Excercises 

# 1. Create a search of a organism or set of organisms. 
# 2. Use the summary or fetch arguement to extract relavent information to your search. 
# 3. Create a plot to see how this topic has been reported on over a particular time span. 







