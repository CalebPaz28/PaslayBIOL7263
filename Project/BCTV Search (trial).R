snippet ## ---------------------------
##
## Script name: BCTV Work
##
## Purpose of script:
##
## Author: Caleb Paslay
##
## Date Created: 2022-09-26
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## load the packages needed:  

require(tidyverse)
library(rentrez)

entrez_dbs()
entrez_db_searchable(db="protein")

bctv_search <- entrez_search(db="nucleotide", term ="beet curly top virus")
bctv_search
bctv_search$retmax
bctv_search$count
bctv_search$file
bctv_search$QueryTranslation


