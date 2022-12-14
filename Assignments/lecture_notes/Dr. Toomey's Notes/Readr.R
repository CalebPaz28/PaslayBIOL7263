Data Import and Export with readr
M. Toomey
2022-09-19
Readr is a package that is part of Tidyverse with a range of functions to facilitate the parsing and import of data files into R. It replicates and expands many of the existing function in base R

Importing .csv files
Download my ebird dataset from my github account here: https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true

Create a “Data” folder in your project and save this files there.

MBT_ebird<-read_csv("Data/MBT_ebird.csv") #read in my ebird csv file from my github account
You can often read files in directly from the web by putting in the web address as the path.

MBT_ebird<-read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true") #read in my ebird csv file from my github account
Readr has a varitey of other functions to import other data formats

read_tsv() - tab separated data
read_table() - fixed width files with white space separation
read_delim() - any delimiter that you specify
Column Names
By default read_csv willl use the first lines as the column names in the resulting tibble. If there are not column names you can omit them:
  
  MBT_ebird<-read_csv("Data/MBT_ebird.csv", col_names = FALSE)

or you can provide a vector of names:
  
  MBT_ebird<-read_csv("Data/MBT_ebird.csv", co_names = c("entry", "list_ID", "common_name")
                      
                      Parsing
                      View the imported file
                      
                      glimpse(MBT_ebird)
                      You will notice that date and time columns were automatically assigned to the correct data type. Readr uses the following rules, by default to classify data as it is reads in:
                        
                        logical: contains only “F”, “T”, “FALSE”, or “TRUE”.
                      integer: contains only numeric characters (and -).
                      double: contains only valid doubles (including numbers like 4.5e-5).
                      number: contains valid doubles with the grouping mark inside.
                      time: matches the default time_format.
                      date: matches the default date_format.
                      date-time: any ISO8601 date.
                      If none of these rules apply, then the column will stay as a vector of strings.
                      
                      For specific data import problems these rules can be overridden with specifications within the the function call. More details here: https://readr.tidyverse.org/articles/readr.html
                      
                      Importing directly from Excel and googlesheets not recommended
                      There are tools to do this, but I would avoid this if possible as these are likely to be buggy and unpredictable.
                      
                      Excel - https://readxl.tidyverse.org/
                        GoogleSheets - https://googlesheets4.tidyverse.org/
                        Exporting data
                      Readr can export tibbles you create in R is several formats:
                        
                        write_delim(x, file, delim = " ") - Write files with any delimiter.
                      write_csv(x, file) - Write a comma delimited file.
                      write_tsv(x, file) - Write a tab delimited file.