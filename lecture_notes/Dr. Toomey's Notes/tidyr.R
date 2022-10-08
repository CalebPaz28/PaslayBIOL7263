Tidying Data
M. Toomey
2022-09-29
Up to now we have been working with single datasets that are “tidy” and organized in a way that make them easy to work with in R and the tidyverse family of packages. In this lesson we will introduce tools that can help you transform “messy” data into tidy data.

The three rules of tidy data
Each variable must have its own column.
Each observation must have its own row.
Each value must have its own cell.

A schematic of tidy data organization reproduced from chapter 12 of Wickham and Grolemund, R for Data Science

Benefits of tidy data
Easily adapt old scripts to process new data
Variables as columns allows you to easily use vectorized functions
Pivoting
Two common problems encounter in non-tidy data are:
  
  One variable might be spread across multiple columns.
One observation might be scattered across multiple rows.
The tidyr package in the tidyverse provides tools to pivot and reoraganize data tables that can quickly resolve these problems.

Column name to a string varaible
The relig_income is a built-in dataset, in the tidyverse that included counts from a survey of religion and annual income.

relig_income
each row is a different religion
the income variable is spread across the column headers
the count values are individual cells
To make this tidy data we need to convert to three columns:
  
  religion
income
count
We want a long dataset with many rows that are each a unique observation. To do this we can pivot_long

relig_income %>% 
  pivot_longer(cols = c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k", "$50-75k", "$75-100k", "$100-150k", ">150k", "Don't know/refused"), names_to = "income", values_to = "count")

#We can simplify this by specifying the range of columns
relig_income %>% 
  pivot_longer(cols = "<$10k":"Don't know/refused", names_to = "income", values_to = "count")

#We can simplify this by selected the "not religion" rather than specifying all of the columns individually
relig_income %>% 
  pivot_longer(cols = !religion, names_to = "income", values_to = "count")
The first argument is the dataset we want to pivot relig_income. We then pipe that to the the pivot_long function

In pivot_long:
  
  First we specify the columns to be pivoted.
Then indicate that the column names should become a variable called income
Finally indicate that the values in the cells should become observations of a variable called count.
Column name to a numeric varaible
Some messy datasets may contain numeric values in the column names. Pivot contains tools that makes it easy to extract and format these values.

The billboard dataset contains the top 100 rankings each week for songs release in the year 2000. In this dataset each week is a column, but we would like week to be a single column numeric variable.

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), #pivot all columns with names beginning with "wk"
    names_to = "week", #convert column names to a variable called week
    values_to = "rank", #reorganize observations in each column into a variable called rank
    values_drop_na = TRUE #drop NAs from the pivoted data set
  )
If you look at the variable types week is a not a numeric variable. We need to parse week further to get the output we want.

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), #pivot all columns with names beginning with "wk"
    names_to = "week", #convert column names to a variable called week
    names_prefix = "wk", #this command strips off the "wk" prefie from the column name
    names_transform = list(week = as.integer), #this option transforms the variable type from a string to integer
    values_to = "rank", #reorganize observations in each column into a variable called rank
    values_drop_na = TRUE, #drop NAs from the pivoted data set
  )
Column name contains multiple variables
In the who data set the column names contain three variables:
  
  A prefix that indicates these are new cases new/new_. This is the same for all observations and can be dropped.
A diagnosis method: sp/rel/ep
Gender m/f
Age range: 014/1524/2535/3544/4554/65
We can use regular expression within the pivot function to parse these into separate variables:
  
  who %>% pivot_longer(
    cols = new_sp_m014:newrel_f65, #specify the range of columns to pivot
    names_to = c("diagnosis", "gender", "age"), #specify the new names for the variables that will be extracted from the column names
    names_pattern = "new_?(.*)_(.)(.*)", #use "("")" to select elements of the regular expression. Here the "?" indicates 0 or 1 "_" is possible after "new". 
    values_to = "count"
  )
Columns are multiple observations of same individuals
For this example we will generate a sample data set called family:
  
  family <- tribble(
    ~family,  ~dob_child1,  ~dob_child2, ~gender_child1, ~gender_child2,
    1L, "1998-11-26", "2000-01-29",             1L,             2L,
    2L, "1996-06-22",           NA,             2L,             NA,
    3L, "2002-07-11", "2004-04-05",             2L,             2L,
    4L, "2004-10-10", "2009-08-27",             1L,             1L,
    5L, "2000-12-05", "2005-02-28",             2L,             1L,
  )
family <- family %>% mutate_at(vars(starts_with("dob")), parse_date)

# A tibble: 5 x 5
family dob_child1 dob_child2 gender_child1 gender_child2
<int> <date>     <date>             <int>         <int>
  1      1 1998-11-26 2000-01-29             1             2
2      2 1996-06-22 NA                     2            NA
3      3 2002-07-11 2004-04-05             2             2
4      4 2004-10-10 2009-08-27             1             1
5      5 2000-12-05 2005-02-28             2             1
In this data set we have both dob and gender observations for child #1 and #2. We would like to tidy this, create a new variable child and have single dob and gender variables. Again, pivot gives us options to do this:

family %>% 
  pivot_longer(
    col = !family, #pivot columns that are not family
    names_to = c(".value", "child"), #transform column names to two variables. The special name ".value" tells pivot_longer() that that part of the column name specifies the “value” being measured (which will become a variable in the output) 
    names_sep = "_", #This tells pivot_longer() to split the column names at the "_". 
    values_drop_na = TRUE
  )
pivot_wider()
In cases where you have observations spread across multiple rows, you can tidy these by widening the dataset with pivot_wider()

The built in dataset called table2 contains data on the population of a country and the number of cases of a disease observed, but the observations are collected in a single column count and labeled as population or cases by the the column type.

require(tidyverse)
## Loading required package: tidyverse
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
## ✔ ggplot2 3.3.6      ✔ purrr   0.3.4 
## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
## ✔ tidyr   1.2.1      ✔ stringr 1.4.1 
## ✔ readr   2.1.2      ✔ forcats 0.5.2 
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
table2
## # A tibble: 12 × 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
What we want are two new columns named population and cases that contain the values in the count column.

table2 %>%
  pivot_wider(names_from = type, values_from = count)
Separating one column to many
Sometimes you will encounter data sets where a single column contains two or more values. These can be pulled apart with the separate() function.

For example, table 3 is a version of table 2 where the cases and population are expressed as rate.

table3
## # A tibble: 6 × 3
##   country      year rate             
## * <chr>       <int> <chr>            
## 1 Afghanistan  1999 745/19987071     
## 2 Afghanistan  2000 2666/20595360    
## 3 Brazil       1999 37737/172006362  
## 4 Brazil       2000 80488/174504898  
## 5 China        1999 212258/1272915272
## 6 China        2000 213766/1280428583
We can create separate cases and population variables by splitting rate at the “/”.

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")
However, since rate was a character vector, the split columns are now character vectors which is not what we want. We can change them to integers by including the convert = TRUE option.

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)
convert will apply the classification rules we discussed in the data import section of Lesson 5.

A common problem you might encounter is that someone has mixed data entries with sample notes in a single cell. separate() can help you here.

Let’s make a small example data set field_notes

field_notes<-tibble(
  ID = c(023, 456, 167, 897), 
  sex = c("F","F","M","F"),
  mass = c("15.6 first sample of the day","16.0","17.2 caught with female 456","14.9 last sample of the day"))

field_notes
## # A tibble: 4 × 3
##      ID sex   mass                        
##   <dbl> <chr> <chr>                       
## 1    23 F     15.6 first sample of the day
## 2   456 F     16.0                        
## 3   167 M     17.2 caught with female 456 
## 4   897 F     14.9 last sample of the day
Notice that mass also contains sample notes and everything is separated by a space. We would like separate coloumns for mass and notes. We can separate by space, but this does not do exactly what we would like.

field_notes %>% 
  separate(mass, 
           into = c("mass","notes"), 
           sep = " ")
It only recovers one of the words from the mote. separate has an option extra that allows you to merge the extra stuff into the second column:
  
  field_notes %>% 
  separate(mass, 
           = c("mass","notes"), 
           sep = " ", 
           extra = "merge")
This is almost what we want but the mass is still being treated as a string. We need to convert to have it treated as numeric (double).

field_notes_sep<-field_notes %>% 
  separate(mass, 
           into = c("mass","notes"), 
           sep = " ", 
           extra = "merge", 
           convert = TRUE)

field_notes_sep
Merging columns with unite()
unite() is the inverse of separate() and brings many columns togerther into one.

field_notes_sep %>% 
  unite(col = ID_sex, ID, sex)
By default unite() joins the values in the columns with an "_" and deletes the joined columns. However, we can control this behavior by changing the options.

field_notes_sep %>% 
  unite(col = ID_sex, ID, sex,
        sep = "&",  #this specifies a "&" as the separator
        remove = FALSE)  #this will retain the joined columns in the result
