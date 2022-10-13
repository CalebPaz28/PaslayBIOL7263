#### R Tutorials 

#Data frames 

#A data frame is a rectangular collection of values, usually organized so that variables
# apppear in the columns and observations in rows. 

library(tidyverse)
library(ggplot2)
mpg

?mpg #use this to access help about the dataframe "mpg". This can also be used
# to access other help-related information for different packages or objects. 

#You can even create a help page for your own data if needed. 

?mpg("drv") # use this to find info on a specific variable. 

?mpg("class")

colnames(mpg)

rownames(mpg)

as_tibble(mpg) #use this to convert a non-tibble into a tibble. (user-friendly)

####Common types of variables used with tibbles 
#Int stands for integers.
#dbl stands for doubles, or real numbers. 
#chr stands for character vectors, or strings. 
#dttm stands for date-times (a date + a time).
#lgl stands for logical, vectors that contain only TRUE or FALSE. 
#fctr stands for factor, which R uses to represent caegorical variables.
#Date stands for dates. 

### Filtering observations

#Filter() lets us use a logical test to extrct specific rows from a data frame. 

#Using the nycflights13 package, we can view the data set "flights"
library(nycflights13)
library(ggplot2) #using this for greater visualization

flights
?flights

filter(flights, month ==1, day ==1) #select all flights that departed January 1st. 

jan1 <- filter(flights, month ==1, day ==1) # to save the new data frame, apply the assignment operator "<-"

jan1

#Logical comparisons
##Comparison operators
#>, >=, <, <=, != (not equal), and == (equal). Each creates a logical test. 
#Example

pi > 3 #this is TRUE

#Filter applies the test to each row in the data frame and returns the rows that 
#pass the logical operator to form a new data frame. 

### Boolean operators

# & (and), | (or), and ! (not or negation), xor() (exactly or).
# R uses boolean to combine multiple logical comparisions into a single logical test. 

filter(flights, month==11 | month== 12)

#A short hand version for the above code

nov_dec <- filter(flights, month %in% c (11,12))
nov_dec









