

entrez_db_searchable("nuccore")


AMV_search <- entrez_search(db = "nuccore", 
                            term = "alfalfa mosaic virus[ORGN]")

AMV_search

summary(AMV_search)

View(AMV_search)

glimpse(AMV_search)

AMV_seq <- entrez_fetch(db = "nuccore", 
                        id = AMV_search$ids,
                        rettype = "fasta")


write(AMV_seq, file = "Project/amv_seq.fasta")




#####################################################################################################################
Working through rentrez code

library(rentrez)
library(glue)
library(tidyverse)

entrez_dbs() #This gives us the available databases that we can search through

database <- entrez_dbs()
View(database) #This can help in viewing the databases later

entrez_db_searchable(db = "pubmed") #search terms that we can use in assisting our search 

entrez_db_links(db = "pubmed", 
                config = NULL)



cliff_swallow_search <- entrez_search(db = "pubmed", 
                 term = "cliff swallows[TITL] AND 2000:2021[PDAT]")


write.csv(cliff_swallow_search, file = "Project/cliff_swallow.csv")

entrez_db_summary(db = "pubmed")















