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
# We can also use && and ||. (These are NOT used with filter).

filter(flights, month==11 | month== 12)

#A short hand version for the above code

nov_dec <- filter(flights, month %in% c (11,12))
nov_dec

##NA##

#Missing values can be tricky for R. R will use "NA" to represent missing data. 

#Example
x <- NA
y <- NA
x==y # returns [1] NA

#To determine if  a value is missing, we can use is.na()
is.na(x) # returns [1] TRUE

#To preserve NA's when filtering we can ask for them.
df <- tibble(x=c(1,NA,3))
filter(df,x >1)

filter(df, is.na(x) | x>1)

filter(flights, arr_delay > 2)

houston_dest <- filter(flights, dest=="HOU")
houston_dest

american <- filter(flights, carrier=="AA")
united <- filter(flights, carrier=="UA")
delta <- filter(flights, carrier=="DL")


depart_july <- filter(flights, month==7)
depart_august <- filter(flights, month==8)
depart_september <- filter(flights, month==9)

arrive <- filter(flights, arr_delay>2 & dep_delay == 0)

flight_time <- filter(flights, dep_delay > 60 & air_time >30)
flight_time
departed <- filter(flights, dep_time > 2359 & dep_time < 600)
departed

#A useful dplyr filtering helper is between(). 
?between()

filter(flights, is.na(dep_time))

?flights

### Learning how to derive new variable from a data.frame 

flights
?flights
library(tidyverse) #loads dplyr, ggplot2, and others. 

# Mutate() allows use to assimilate new variables from preexisting ones. 
#Mutate adds new variables to the end of the data set.

# We can narrow the data set by using the select() function. 

flights_sm <- select(flights, #First we will create a narrow data set to see mutate in action. 
                     arr_delay, 
                     dep_delay, 
                     distance, 
                     air_time)
flights_sm

#Mutate() returns a new data frame that contains the new variables appended to a copy
# of the original data set. 

mutate(flights_sm, 
       gain = arr_delay - dep_delay, #gain is our new variable
       speed = distance/air_time * 60 # speed is our other new variable
       )
mutate(flights_sm, 
       gain = arr_delay - dep_delay,
       hours = air_time / 60, 
       gain_per_hour = gain / hours # We can call our new variables in the same code. 
       )

#Mutate() will always return the new variables appended to a copy of the original data. 
#Transmutate() can be used to return only the new variables. 

transmute(flights,#use this to create a new data frame with the new variables ONLY. 
       gain = arr_delay - dep_delay,
       hours = air_time / 60, 
       gain_per_hour = gain / hours 
)

## Functions can be used inside mutate() as long as the function is vectorised.
#This means that the vector of values as input and vector of values as output are equal.

#Arithmetic operators: +, -, *, /, ^. (These get recycled: If a parameter is shorter than 
# another, the operator will be repeated multiple times to create a vector of the same length.)

#modular arithmetic: %/% (integer division) and %% (remainder), where x == y * (x %/% y) + (x %% y).
# This is useful to break integers up into pieces. 

###EXAMPLE###
transmute(flights, 
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
          )

#Logs: log(), log2(), log10(). Logarithms are an incredibly useful transformation for data
# across multiple orders of magnitude. They also convert multiplicative to additive. 

#offsets: lead() and lag() allow you to refer to leading or lagging values. 
# x - lag(x) or find when values change x != lag(x). 

x <- 1:10
x
lag(x)
lead(x)

## Cumulative and rolling aggregates: R provides functions for running sums, products,
# mins and maxes: cumsum(), cumprod(), cummin(), cummax() and dplyr has cummean().

x
cumsum(x)
cummean(x)

# Logical comparisons: <, <=, >, >=, !=, 

## Ranking: This ranks values from 1st, 2nd, 3rd, etc. Use min_rank(), the default gives
# smallest values the small ranks. Use desc() to give the largest values the smallest ranks.
# min_rank() may not work so use row_number(), dense_rank(), percent_rank(), cume_dist(), ntile().
y <- c(1,2,2,NA,3,4)
min_rank(y)
min_rank(desc(y))

flight_sm <- select(flights,
                    dep_time, 
                    sched_dep_time,
)
flight_sm

transmute(flights,
         hour = dep_time %/% 100,
          minute = dep_time %% 100
         )

transmute(flights,
          
         hour = sched_dep_time %/% 100,
          minute = sched_dep_time %% 100)

flights_select <- select(flights,
                         air_time,
                         arr_time,
                         dep_time)
flights_select

flights_1 <- mutate(flights_select, 
                    wait_time = arr_time - dep_time)
flights_1


departed_delay <- select(flights, dep_delay)
departed_delay
min_rank(departed_delay)
min_rank(desc(departed_delay))

1:3 + 1:10
### Trigonometric functions
?Trig
?learnr

?question
library(learnr)

###Summarise Tables###
flights

# Summarise() collapses a data frame to a single row of summaries. 

summarise(flights, delay = mean(dep_delay, na.rm = TRUE),
          total = sum(dep_delay, na.rm = TRUE))
# We give summarise() the 1. Name of data frame to transform 2. one or more column names to appear in transformed output. 

# The main difference between summarise and mutate is the type of function that you 
# use to generate the new column. Mutate() takes functions that return an entire vector of output.
 # Summarise() takes functions that return a single value (or summary). 

# Summarise() becomes more useful when paired with group_by()
# group_by() changes the unit of analysis of the data frame: it assigns observations
# in the data frame to separate groups. 

##Example## 
# summarise() code above computes the average delay for the entire data set. If we 
# apply exactly the same code to a data set that has been grouped by date, we get
# the average delay per date. 

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE),
          total = sum(dep_delay, na.rm = TRUE))



## grouping by multiple variables
daily <- group_by(flights, year, month, day)
(per_day <- summarise(daily, total = sum(dep_delay, na.rm = TRUE)))
(per_month <- summarise(per_day, total = sum(dep_delay, na.rm = TRUE)))
(per_year <- summarise(per_month, total = sum(total, na.rm = TRUE)))

## Use ungroup() to remove grouping and return operations
daily <- ungroup(daily) # no longer grouped  by date
summarise(daily, total =sum(dep_delay, na.rm = TRUE)) #all flights

## Combining multiple operations 
##Example## 

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay
delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

###Pipes###
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

## Aggregating Functions: take a vector of values and returns a single value. 
## EXAMPLES ##
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay >0]) # average positive delay
  )

## Measures of spread: sd(x), IQR(x), mad(x). The standard deviation, interquartile range, 
# and median asolute deviation are useful. 

# Why is the distance to some destinations more variable than to others?
not_cancelled %>%
  group_by(dest) %>%
  summarise(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))


### Measures of rank: min(x), quantile(x,0.25), max(x). Quantiles are a generalisation of the median.
# quantile(x,0.25) will find a value of x that is greater than 25% of the values, 
# and less than the remaining 75%. 

#When do the first and last flights leave each day?
not_cancelled %>%
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

### Measures of position: first(x), nth(x,2), last(x). These work similarily to 
# x[1], x[2], and x[length(x)] but let you set a default value if that position does not
# exist. 
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

# The above functions are similar to filtering on ranks. 
not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

## Counts: n(), which takes no arguments, and returns the size of the current group. 
# To count the number of non-missing values use sum(!is.na(x)). To count the number
# of distinct values, use n_distinct(x).

#Which destinations have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

C






