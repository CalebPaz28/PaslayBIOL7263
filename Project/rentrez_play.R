

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
