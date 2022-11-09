#load required packages



#### Basic functions 

entrez_dbs() #gives a list of databases that rentrez works with


entrez_db_summary() #gives a summary of a given database


entrez_db_searchable() #key terms that are used to narrow searches


entrez_db_links() #set of databases that may contain linked records 


### Searching databases 

bullfrog_search <- entrez_search(db = "pubmed", term = "bullfrog") #the objject returned acts like a list
bullfrog_search #print the list

bullfrog_search$ids #the ids are most important here. They allow for us to fetch records and get summaries of data. 

bullfrog_search1 <- entrez_search(db = "pubmed", term = "bullfrog", retmax = 40) #get more ids
bullfrog_search1
bullfrog_search1$ids

### Building search terms

entrez_db_summary(db = "sra") #sequence read archive


entrez_search(db = "sra",
              term = "bullfrog[ORGN]", retmax = 0) #add key terms 


entrez_search(db = "sra",
              term = "bullfrog[ORGN] AND 200:2019[PDAT]") #add boolean operators, use () to be explict


### Advanced counting

search_year <- function(year, term){
  query <- paste(term, "AND(", year, "[PDAT])")
  entrez_search(db = "pubmed", term = query, retmax=0)$count
}

year <- 1980:2020
papers <- sapply(year, search_year, term ="Connectome", USE.NAMES = FALSE)



plot(year, papers, type ='b', main = "the rise of the connectome")



### finding cross-references (allowing users to find the links between databases and sources)

all_the_links <- entrez_link(dbfrom = "gene", id = 193034, db = "all")

all_the_links$links #a list will appear with the format [1][source]_[linked_database]

all_the_links$links$gene_pmc[1:10] #Pubmed central

all_the_links$links$gene_clinvar #No human relavance because it is a pepper gene


# Another example 

entrez_search(db = "gene", term = "BRCA1[TITL] AND human[ORGN]", retmax = 1)$ids #search for an ID

all_the_links1 <- entrez_link(dbfrom = "gene", id = 672, db = "all") #BRCA1 gene
all_the_links1
all_the_links1$links

all_the_links1$links$gene_clinvar[1:10]


# Narrow the linked search 

nuc_links <- entrez_link(dbfrom = "gene",id = 672, db = "nuccore")
nuc_links
nuc_links$links #provides us with the links within nuccore database

ref_links <- nuc_links$links$gene_nuccore_refseqrna[1:10] #finding IDs that match unique transcripts from our gene of interest

entrez_fetch(db = "gene" , id = nuc_links, rettype = "fasta") #to large to fetch
entrez_summary(db = "gene" , id = nuc_links) #to large to view



### External Links

paper_links <- entrez_link(dbfrom= "pubmed", id = 25500142, cmd = "llinks")
paper_links

paper_links$linkouts
linkout_urls(paper_links)


### Getting summary data 
# after using entrez_search or entrez_link to obtain unique ids of interest to your search, rentrez offers two ways to obtain
# those records. We can fetch "full" records in various formats or summary less information about each record. 

brca1_summ <- entrez_summary(db = "pubmed", id =32091409)
brca1_summ #again, the obejct returned is like a list

brca1_summ$pubdate 
brca1_summ$pmcrefcount #how many times this id has been cited in pubmed central papers


#Working with many records

brca_search <- entrez_search(db = "pubmed", term = "(brca1 mutation AND human[ORGN]) AND 2015:2020[PDAT]",
                             retmax = 40)
brca_search


multi_summs <- entrez_summary(db = "pubmed", id = brca_search$ids)
multi_summs

#Helper function that takes one or more elements from every summary record in one of these lists.

extract_from_esummary(multi_summs, "title")

#Extract several elements

date_and_cite <- extract_from_esummary(multi_summs, c("pubdate", "pmcrefcount", "title"))
knitr::kable(head(t(date_and_cite)), row.names = FALSE)



## Fetching Data nucleotide data

pydv_search1 <- entrez_search(db = "nuccore", term = "potato yellow dwarf virus[ORGN]")

pydv_search1

all_pydv_search <- entrez_fetch(db = "nuccore", id = pydv_search1$ids, rettype = "fasta")
class(all_pydv_search)

nchar(all_pydv_search)

write(all_pydv_search, file ="my_transcripts.fasta")

## Fetching publication data
pydv_search2 <- entrez_search(db = "pubmed", term = "potato yellow dwarf virus[ORGN] AND 2000:2022[PDAT]")

pydv_search2

all_pydv_search1 <- entrez_fetch(db = "pubmed", id = pydv_search2$ids, rettype = "fasta")
class(all_pydv_search1)

nchar(all_pydv_search1)

write(all_pydv_search1, file ="my_transcripts.fasta")



