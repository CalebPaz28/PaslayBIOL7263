snippet ## ---------------------------
##
## Script name: Rentrez?Entrez Walkthrough 
##
## Purpose of script: 
##
## Author: Caleb Paslay
##
## Date Created: 2022-09-22
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## Helpful points (Key terms for entrez_fetch) 
(Link)[https://www.ncbi.nlm.nih.gov/books/NBK25499/table/chapter4.T._valid_values_of__retmode_and/]

install.packages("rentrez")
## load the packages needed:  

require(tidyverse)
install.packages("rentrez") #first we will need to install the package
library(rentrez) # now we can load rentrez
require(rentrez)

entrez_dbs() #this option gives us a list of the NCBI databases
entrez_db_summary("nucleotide") #we can specify for a summary of a particular database
entrez_db_summary("protein")

entrez_db_summary() # brief description of what the database is 
entrez_db_searchable() # set of search terms that can be used with a database
entrez_db_links() #set of databases that might contain linked records

entrez_db_summary("nucleotide")
entrez_db_searchable("nucleotide") 

r_search <- entrez_search(db = "pubmed", term = "R language") # we need db (database) 
# and we need a search term 

print(r_search) #when you print, you'll see a high number of search results, 
# but only 20 ID's. This is because 20 is the default maximum. 

# We can can access/fetch the ID's by using
r_search$ids

# We can change the default max by adding "retmax"
another_r_search <- entrez_search(db = "pubmed", term = "R language", retmax = 40)
print(another_r_search)
another_r_search$ids 

#We can search a database using query[SEARCH FIELD] and combine searches using AND, OR, and NOT. 
entrez_search(db = "sra", term = "tetrahymena thermophila[ORGN]", retmax=0)

#WE can narrow our search by including only records added recently using colons to specify ranges
entrez_search(db = "sra", term = "tetrahymena thermophila[ORGN] AND 2020:2022[PDAT]", retmax=0)
entrez_search(db = "sra", term = "tetrahymena thermophila[ORGN] AND 2010/01/01:2011/01/01[PDAT]", retmax=0)
# we can include the OR operator to combine the search terms
entrez_search(db = "sra", term = "tetrahymena thermophila[ORGN] or Tetrahymena borealis[ORGN] AND 2020:2022[PDAT]", retmax=0)

# Filtering - allows for ... filtering

# MeSH (Medical subject headings)
entrez_search(db = "pubmed", term = "(vivax malaria[MeSH]) AND (folic acid antagonists[MeSH])")

# Interestingly we can use the search function to establish trends in a given field
search_year <- function(year, term){
  query <- paste(term, "AND (", year, "[PDAT])") 
  entrez_search(db="pubmed", term=query, retmax=0)$count
}
year <- 2008:2014
papers <- sapply(year, search_year, term="Connectome", USE.NAMES = FALSE)
plot(year, papers, type='b', main="The Rise of the Connectome")

# One useful aspect of NCBI is the degree to which records of one type are connected
# This can be used by the function entrez_link()
all_the_links <- entrez_link(dbfrom = 'gene', id =351, db ='all')
all_the_links
#We can view the list of links using $ or print
all_the_links$links #simpilar way
print(all_the_links$links)


all_the_links$links$gene_pmc[1:10]

all_the_links$links$gene_clinvar

nuc_links <- entrez_link(dbfrom='gene', id=351, db = "nucleotide")
nuc_links <- entrez_link(dbfrom='gene', id=351, db = "nuccore")

nuc_links$links

nuc_links$links$gene_nuccore_refseqrna

entrez_fetch(db = "nuccore", id = 1889693417, rettype = "default")

#External Links
paper_links <- entrez_link(dbfrom="pubmed", id = 25500142, cmd="llinks")
paper_links
paper_links$linkouts

# to extract the URL's we can use another code
linkout_urls(paper_links)

# we can also using more than one ID when linking
all_links_together <- entrez_link(db = "protein", dbfrom = "gene", id = c("93100", "223646"))
all_links_together
all_links_together$links$gene_protein

# This is useful but the protein ID and gene ID is lost
# To retain that info we use by_id to TRUE
all_links_sep <- entrez_link(db = "protein", dbfrom = "gene", id = c("93100", "223646"), by_id = TRUE) 
all_links_sep
lapply(all_links_sep, function(x) x$links$gene_protein)

# entrez_fetch() returns full records in varying formats and entrez_summary()
# return less information. 
## Summary Record

taxize_summ <- entrez_summary(db = "pubmed", id=24555091)
taxize_summ

# Information returned by the entrez_summary acts like a list
# We can extract elements from the list using $

taxize_summ$articleids
taxize_summ$sortpubdate
taxize_summ$pmcrefcount

## A vector for more than 1 ID can be established and a list
# of summary records will be given back. 

bctv_search <- entrez_search(db= "nucleotide", term="beet curly top virus AND complete")
bctv_search
bctv_search$ids
#So we can build the search and plug it into an additional vector to get a summary
# of all the search criteria
bctv_multi_summ <- entrez_summary(db="nucleotide", id=bctv_search$ids)

#rentrez also has a helpful function, extract_from_esummary()
#This takes one or more elements from every summary record in one of the lists

extract_from_esummary(bctv_multi_summ, "title")

# Or take several elements
title_and_date <- extract_from_esummary(bctv_multi_summ, c("author OR authors", "title"))
View(title_and_date)
knitr::kable(head(t(title_and_date)), row.names=FALSE)

#Summary records are useful, but may not include all relevant information
# We can use entrez_fetch() to get a complete representation
# We will also use rettype to specify formatting

gene_ids <- c(351, 11647)
linked_seq_ids <- entrez_link(dbfrom="gene", id=gene_ids, db="nuccore")
linked_transcripts <- linked_seq_ids$links$gene_nuccore_refseqrna 
head(linked_transcripts)
linked_transcripts

all_recs <- entrez_fetch(db="nuccore", id=linked_transcripts, rettype="fasta")
class(all_recs)
nchar(all_recs)

cat(strwrap(substr(all_recs, 1, 500)), sep="\n")
# Write the command to a file 
write(all_recs, file="my_transcripts.fasta")

temp <- tempfile()
write(all_recs, temp)
parsed_recs <- ape::read.dna(all_recs, temp)

# We can fetch parsed XML documents
Tt <- entrez_search(db="taxonomy", term="(Tetrahymena thermophila[ORGN]) AND Species[RANK]")
tax_rec <- entrez_fetch(db="taxonomy", id=Tt$ids, rettype="xml", parsed=TRUE)
class(tax_rec)
tax_list <- XML::xmlToList(tax_rec)

tax_list&Taxon&GeneticCode

