

#Practice with rentrez (https://www.youtube.com/watch?v=3-7yfdh2eDE)
#Using publication data to determine the number of publications


#Load rentrez
library(rentrez)
#load tidyverse
library(tidyverse)
#load glue
library(glue)
#load ggplot2
library(ggplot2)

API (application programming interface) is a way for computer programs to communicate. 

Rentrez gives us access the the URL for NCBI and Pubmed databases. 

entrez_dbs() #gives us a view of availible databases that we can interact with 

entrez_db_summary(db = "pubmed") #Provides quick summary of the database. Number of submissions and date last updated.

entrez_db_summary(db = "nuccore") 

entrez_db_summary(db = "taxonomy")

entrez_db_searchable(db = "pubmed")#provides us with key terms we can use in search for specific topics. 

?entrez_db_searchable(db = "pubmed") #to see information on this code


key_terms <- entrez_db_searchable(db = "pubmed") #I prefer to make an obeject to more easily view the key terms
View(key_terms)

entrez_search(db = "pubmed" ,
              term = "eugenics") #how we can search terms 

s <- entrez_search(db = "pubmed", 
              term = "alfalfa mosaic virus") 

glimpse(s)

entrez_search(db = "pubmed", 
              term = "Toomey MB[AUTH]")


entrez_search(db = "pubmed", 
              term = "Toomey MB[AUTH] AND pigment") #add an extra layer to this search


entrez_search(db = "pubmed", 
              term = "Toomey MB[AUTH] OR ....") #ask Dr. Toomey about a co-author

###############################################################################################################


entrez_search(db = "pubmed",
              term = "Toomey MB[AUTH]")

entrez_search(db = "pubmed",
              term = "Toomey MB[AUTH] OR bird coloration")


entrez_search(db = "pubmed",
              term = "Toomey MB[AUTH] AND bird coloration")

Toomey_coloration <- entrez_search(db = "pubmed",
                                   term = "Toomey MB[AUTH] AND bird coloration")
View(Toomey_coloration)

Toomey_coloration <- entrez_search(db = "pubmed",
                                   term = "Toomey MB[AUTH] AND bird coloration")

View(Toomey_coloration)

entrez_fetch(db = "pubmed",
             id = Toomey_coloration$ids, rettype = "fasta") 


entrez_search(db = "pubmed",
              term = "alfalfa mosaic virus")


AMV_search <- entrez_search(db = "pubmed",
                            term = "alfalfa mosaic virus")

entrez_db_searchable(db = "pubmed")

entrez_search(db = "pubmed",
              term = "alfalfa mosaic virus[TITL] OR AMV[TITL]") #search for AMV within the title

entrez_search(db = "pubmed",
              term = "alfalfa mosaic virus[TITL]) OR AMV[TITL] AND 2020[PDAT]") #search for AMV within 2020


entrez_search(db = "pubmed",
              term = "alfalfa mosaic virus[TITL]) OR AMV[TITL] AND 2020[PDAT]")$count


entrez_search(db = "pubmed",
              term = "alfalfa mosaic virus[TITL]) OR AMV[TITL] AND 1950:2022[PDAT]")$count

?glue

year <- 1950:2022 #Creating a range from 1950:2022
alfalfa_search <- glue("alfalfa mosaic virus[TITL]) AND {year}[PDAT]")
tomato_search <- glue("tomato yellow leaf curl virus[TITL] AND {year}[PDAT]")

tibble(year = year,
       alfalfa_search = alfalfa_search) %>% 
  mutate(alfalfa= map_dbl(alfalfa_search, ~entrez_search(db="pubmed",
                                                           term = .x)$count))
       
search_count <- tibble(year = year,
                       alfalfa_search = alfalfa_search) %>% 
  mutate(alfalfa = map_dbl(alfalfa_search, ~entrez_search(db="pubmed",
                                                        term = .x)$count))

search_count %>% 
  ggplot(aes(x= year, y = alfalfa))+
  geom_line()
       
       

##############################################################################################
#Plotting two different searches together

year <- 1950:2022
alfalfa_search <- glue("alfalfa mosaic virus[TITL]) AND {year}[PDAT]")
tomato_search <- glue("tomato yellow leaf curl virus[TITL] AND {year}[PDAT]")

tibble(year = year,
       alfalfa_search = alfalfa_search, 
       tomato_search = tomato_search) %>% 
  mutate(alfalfa = map_dbl(alfalfa_search, ~entrez_search(db="pubmed",
                                                          term = .x)$count),
         tomato = map_dbl(tomato_search, ~entrez_search(db="pubmed",
                                                        term = .x)$count))


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
           geom_line()


###########################################################################################################
#Plotting three different lines
year <- 1950:2022
alfalfa_search <- glue("alfalfa mosaic virus[TITL]) AND {year}[PDAT]")
tomato_search <- glue("tomato yellow leaf curl virus[TITL] AND {year}[PDAT]")
bctv_search <- glue("beet curly top virus[TITL] AND {year}[PDAT]")

search_countss <- tibble(year = year,
                         alfalfa_search = alfalfa_search, 
                         tomato_search = tomato_search,
                         bctv_search = bctv_search) %>% 
  mutate(alfalfa = map_dbl(alfalfa_search, ~entrez_search(db="pubmed",
                                                          term = .x)$count),
         tomato = map_dbl(tomato_search, ~entrez_search(db="pubmed",
                                                        term = .x)$count),
         beet = map_dbl(bctv_search, ~entrez_search(db = "pubmed",
                                                    term =.x)$count))


search_countss %>% 
  select(year, alfalfa, tomato, beet) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name, 
             color = name)) +
  theme_bw() +
  geom_line()



############################################################################################################
#Compare the rate of BCTV papers to ALL papers published. 

year <- 1950:2022
bctv_search <- glue("beet curly top virus[TITL] AND {year}[PDAT]")
all_search <- glue("{year}[PDAT]") #this will include all publications from 1950:2022


search_count4 <- tibble(year = year, 
                        bctv_search = bctv_search,
                        all_search = all_search) %>% 
  mutate(bctv = map_dbl(bctv_search, ~entrez_search(db ="pubmed",
                                                    term = .x)$count),
         all = map_dbl(all_search, ~entrez_search(db ="pubmed", 
                                                  term = .x)$count))


search_count4 %>% 
  select(year, bctv, all) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value, 
             group = name, 
             color = name)) +
  theme_bw() + 
  geom_line()
  
                        

search_count4 %>% 
  select(year, bctv, all) %>%
  mutate(relative_bctv = 100 * bctv / all) %>% 
  ggplot(aes(x =year, 
             y = relative_bctv)) +
  theme_bw()+
  geom_line() #This gives us the relative number of publications of BCTV in comparision to ALL over time. 
             





