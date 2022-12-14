Wrangling Data with dplyr
M. Toomey
8/17/2022
The dplyr package contains a set of functions that are helpful in wrangling datasets into a useful format. The functions in dplyr are referred to as verbs because they generally describe the action that will be done to the dataset.

The core ‘verbs’
select()
arrange()
filter()
summarize() and group_by()
mutate()
Verbs work in similar ways:
  
  First you specify the data frame or tibble ytou want to apply the action to
Specify the arguements that describe what you want to do using variable names (without quotes)
A new date frame is produced, usually
What is a tibble?
  “a modern take on data frames”
said to keep the great aspects of data frames and drops the frustrating ones (i.e. changing variable names, changing an input type)
tibble don’t have row names! If you coerce a data frame to a tibble you will need to specify a new column for the row names.
library(tidyverse)

mtcars #a built in dataframe

as_tibble(mtcars) #row names are lost!

as_tibble(mtcars, rownames = "make_model") #row names are now a varible in the tibble called make_model
select(): variables (columns)
by their names
can specify range of column names left to right with :
  to exclude -(variable name)
can use to rearrange columns by listing in desired order
everything() gives everything not specified in the command
data("starwars")

#prints the first parts of an object to the console 

head(starwars)

#prints the last parts of the object to the console

tail(starwars)

#glimpse transposes columns so they are shown vertically in the console. This is helpful for large data sets where the rightmost columns are truncated in other formats

glimpse(starwars)

#This tibble includes variables of the type "list". To avoid complications, lets drop those from the data set. 

#We will use the select verb which allows us to select variables (columns) by name 

starwars_cut1 <- select(starwars, name:species)

#or by column number

starwars_cut2 <- select(starwars, 1:11)

#we can also select all variables that are not (!) films, vehicles, and starships  

starwars_cut3 <- select(starwars, !c(films, vehicles, starships))

#we can also slect all variables that are not (!) lists  

starwars_cut <- select(starwars, !where(is.list))
Helper functions
contains
ends_with
starts_with
matches uses regular expressions
num_range
#We can create a dataset of just the color variables with the helper `matches` and a regular expression

starwars_color <- select(starwars, name, matches("*color*"))

#We could also do this with `contains'

starwars_color2 <- select(starwars, name, contains("color"))
arrange(): reoders rows
by value of a variable
additional variables break ties
default ascending, desc()
helper gives descending
#We can sort the data set by the values of a variable 

arrange (starwars_cut, by = height) #note the default ascending order

#We can specify descending 

arrange (starwars_cut, by = desc(height)) 

tail(arrange (starwars_cut, by = desc(height))) #note that the observations with missing values are last

#additional variables can be used to break ties

arrange (starwars_cut, by = eye_color, by = desc(mass))
filter(): select observations by their values
### uses >, >=, <, <=,!=, == (not just one!) for comparisons   
### Logical operators: & | !

# filter automatically excludes NAs, have to ask for them specifically 

#returns all observatons where mass is exactly 77 kg
filter(starwars_cut, mass == 77)

#returns all observatons where mass is less than or equal to 77 kg
filter(starwars_cut, mass <= 77)

#returns all observatons where mass is not 77 kg
filter(starwars_cut, mass != 77) #note that NAs have been dropped

#If we want the NAs, we must specify them. Here I used the or operator "|" to ask for all values of mass not 77 and all values that are NAs 
filter(starwars_cut, mass != 77 | is.na(mass))

#compare the results of these two filtering statements

filter(starwars_cut, eye_color == "black" & eye_color == "blue")

filter(starwars_cut, eye_color == "black" | eye_color == "blue")
%in% is a useful way to filter by several variables. This can be helpful if you want to filter by a vector of data identifiers.

filter(starwars_cut, eye_color %in% c("black","blue"))
This chart from the R for Data Science text is helpful for thinking about how to specify sets for filtering:
  
  
  Boolean sets

slice() is another useful tool for subsetting that allows you to select specfic rows of data

slice_head() and slice_tail() select the first or last rows. You can select a specific number of by including n=<NUMBER>
  slice_sample() randomly selects rows.
slice_min() and slice_max() select rows with highest or lowest values of a variable.
# return the top 5 rows of the starwars_cut dataset
slice_head(starwars_cut, n=5)
mutate(): create new variables
creates new variable with functions of existing variables
New variables overwrite existing variables of the same name!
  can also use paste
transmute() - creates separate tibble with new variable
mutate with arithmetic operators
operators: + , - , * , / , ^
  starwars_cut <- mutate(starwars_cut, resid_mass = mass / height) #adds new variable resid_mass on to right side of the data set

starwars_resid <- transmutate(starwars_cut, resid_mass = mass / height) #creates a new data set with just resid_mass

#We can nadd name back in to make the new data set more useful
starwars_resid <- transmute(starwars_cut, name = name, resid_mass = mass / height)

#You can refer to the variable you just created in the same command
starwars_resid <- transmute(starwars_cut, name = name, resid_mass = mass / height, log10_resid_mass = log10(resid_mass))
Other operations
Offsets: lead() and lag() allow you to reference the values of a variable immediately before or immediately after an observation.
Cumulative aggregates: cumsum(),cumprod(),cummin(),cummax(),cummean, allow for the calculation of various values as you step through the observations from first to last. This will be influenced by how the data are arranged.
Logicals: You can apply various logical operations >, <, == etc. and return a variable with values of TRUE,FALSE, or NA.
Ranking: min_rank with return the rank of a value in a variable in ascending order (smallest first). To rank largest first combine: desc(min_rank()
                                                                                                                                         starwars_heft <- transmute(starwars_cut, name = name, heft = min_rank(mass))
                                                                                                                                         Grouping can be a useful tool with mutate. We will explore this more below.
                                                                                                                                         Mutate can also be used to create new string (character) variables in conjuction with regular expression and stringr package that is part of the tidyverse (more later).
                                                                                                                                         summarize(): Collapse values into a summary statisitic
                                                                                                                                         Functions:
                                                                                                                                           location - mean() and median()
                                                                                                                                         spread - sd(), IQR(), mad()
                                                                                                                                         summarize(starwars_cut, mean_mass = mean(mass), SD_mass =sd(mass)) #returns an NA because there are missing values
                                                                                                                                         
                                                                                                                                         summarize(starwars_cut, mean_mass = mean(mass,  na.rm=TRUE), SD_mass =sd(mass,  na.rm=TRUE)) #we can remove these missing values with na.rm=TRUE
                                                                                                                                         More functions
                                                                                                                                         rank - min(), max()
                                                                                                                                         quantile(x, 0.75) - this will return value of x that is grater than 75% of observations and less than 25%
                                                                                                                                           Position - first(), last()
                                                                                                                                         nth(x, 2) - this will return value at specific rank ordered postion. These commands can be ordered with a second vector.
                                                                                                                                         counts
                                                                                                                                         n() - size of current grouping
                                                                                                                                         sum(!is.na(x)) - returns number of non-missing observations
                                                                                                                                         n_distinct(x) - returns the number of unique observations
                                                                                                                                         Adding logical operators gives counts and proportions from sum() and mean()
                                                                                                                                         group_by()
                                                                                                                                         Takes an existing tibble and converts it into a grouped tbl where operations are performed “by group”
                                                                                                                                         
                                                                                                                                         Summarizing all observation of a variable is not particularly interesting. Most often we want to summarize the values of different groups or treatments. dplyr has a group_by command that allows you to define groups and then apply subsequent operations.
                                                                                                                                         
                                                                                                                                         starwars_species<-group_by(starwars_cut, species)
                                                                                                                                         
                                                                                                                                         glimpse(starwars_species)
                                                                                                                                         
                                                                                                                                         summarize(starwars_species, mean_mass = mean(mass,  na.rm=TRUE), SD_mass =sd(mass,  na.rm=TRUE))
                                                                                                                                         We can simplify this and make it easier to read with piping
                                                                                                                                         
                                                                                                                                         Piping
                                                                                                                                         combine a sequence of actions
                                                                                                                                         passes intermediate results on to next functions
                                                                                                                                         format:
                                                                                                                                           space before the pipe %>%
                                                                                                                                           follow with a new line with the next function
                                                                                                                                         Especially useful with summarize function and group_by()
                                                                                                                                         starwars_cut %>% #take the starwars_cut data set and pass it to next step
                                                                                                                                           filter (mass > 0) %>% #filter the incoming data set and pass only observations where mass > 0. This removes NAs
                                                                                                                                           group_by(species) %>% #Group the incoming input by species name and  
                                                                                                                                           summarize(mean_mass = mean(mass), SD_mass =sd(mass)) #calculate mean and sd from the filtered and grouped Data. No intermediate files are created
                                                                                                                                         Our current data set has a number of single observation and missing data so means and sd for some groups are meaningless. Lets just look at groups where we have more than one mass observation.
                                                                                                                                         
                                                                                                                                         starwars_cut %>% 
                                                                                                                                           filter (mass > 0) %>% 
                                                                                                                                           group_by(species) %>%
                                                                                                                                           mutate(count = n()) %>% #Here we create a new variable that is a count of the total numbers of observations. Since the data are now grouped this action will be performed group-wise. 
                                                                                                                                           filter (count > 1) %>% #Now I can filter on that count to select only species where there are more than one observation. 
                                                                                                                                           summarize(mean_mass = mean(mass), SD_mass =sd(mass)) #calculate mean and sd from the filtered and grouped Data. No intermediate files are created
                                                                                                                                         
                                                                                                                                         #We can condense this and remove the mutate verb
                                                                                                                                         
                                                                                                                                         starwars_cut %>% 
                                                                                                                                           filter (mass > 0) %>% 
                                                                                                                                           group_by(species) %>%
                                                                                                                                           filter (n() > 1) %>% #In one step this will calculate the group count and filter by that count
                                                                                                                                           summarize(mean_mass = mean(mass), SD_mass =sd(mass)) 