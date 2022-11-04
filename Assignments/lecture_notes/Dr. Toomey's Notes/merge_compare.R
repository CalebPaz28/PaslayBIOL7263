Merging and Comparing Data Sets
M. Toomey
2022-09-29
These tools are designed to help you merge and compare multiple data sets accurately and efficiently.

Mutating joins
Mutating joins add new variables to a data set from another data set that match observations in in a key variable in each data set.

There are four different types of mutating joins:
  
  inner_join(x,y) - joins matching observations in both x and y
Outer joins
left_join(x,y) - joins all observations in x and adds matching observations from y. By default will add NAs where observations from x have no match in y.
right_join(x,y)- joins all observations in y and adds matching observations in x. By default will add NAs where observations from y have no match in x.
full_join(x,y) - joins all observations from x and all observations from y. By default will add NAs where matching observations are missing in eaither x or y.

A schematic representation of mutating joins reproduced from chapter 13 of Wickham and Grolemund, R for Data Science

Examples from the vignette

We have two data sets band_members and band_instruments that share a key “name”

require(tidyverse)
band_members
## # A tibble: 3 × 2
##   name  band   
##   <chr> <chr>  
## 1 Mick  Stones 
## 2 John  Beatles
## 3 Paul  Beatles
band_instruments
## # A tibble: 3 × 2
##   name  plays 
##   <chr> <chr> 
## 1 John  guitar
## 2 Paul  bass  
## 3 Keith guitar
Try each type mutating join function following this general template:
  
  band_members %>%
  <some join function> (band_instruments, by = "name")
The joining variable name of the keys does not necessarily need to be the same, but that values must match.

band_instruments2 # in this data set the key variable is called artist
## # A tibble: 3 × 2
##   artist plays 
##   <chr>  <chr> 
## 1 John   guitar
## 2 Paul   bass  
## 3 Keith  guitar
We can join this by specifying the keys in the by option

band_members %>% 
  full_join(band_instruments2, by = c("name" = "artist"))
If you want to retain the “artist” variable you can specify keep=TRUE

band_members %>% 
  full_join(band_instruments2, by = c("name" = "artist"), keep=TRUE)
Filtering joins
Filtering joins allow you to filter one date set based on the presence or absence of matches in a second data set. This is a great way to investigate large data sets for missing observations.

semi_join(x,y) returns all rows from x with a match in y.
anti_join(x,y) returns all rows from x without a match in y.
Try each on the band data set:
  
  band_members %>%
  <some filter join function> (band_instruments, by = "name")
Set operations
These are similar to filter joins but work on complete rows comparing the value of every variable. This can be helpful if you have multiple copies of a data set and want to find where there are similarities and differences between them.

intersect(x, y) - return only observations in both x and y.
union(x, y) - return unique observations in x and y.
setdiff(x, y) - return observations in x, but not in y.