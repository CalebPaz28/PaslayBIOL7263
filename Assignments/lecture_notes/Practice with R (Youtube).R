#Practice with R (R Programming 101: YouTube)

##All examples
#How to get data into Rstudio#
my_data <- read.csv("") #This pulls the code into the environment

#Viewing data
head(my_data) #This looks at the first 6 rows
tail(my_data) #This looks at the last 6 rows
View(my_data) #Produces data in a flat spreadsheet

#Rows are observations and columns are variables 

my_data[1,3] #[Row,Column]
my_data[ ,3] #[All of the row, column 3]

install.packages("") #Install only once 
library("") #Use this to load the package. 

#Start of analysis
my_data %>% #This pipes the code into the next set of code ("and then") 
  select(name, age, height) #Using this to select various variables.
%>% filter(age < 24 & Height > 1.78) %>% 
  arrange(height)

# Importing data from an excel document
# Library(readxl) load this to use excel importing 
my_data <- read_excel("Data/friends.xlsx",
                      sheet = "position", 
                      range = "C4:G14",
                      na = "**")

library(tidyverse)

data() #all data sets that R has pre-installed 
View(starwars)
starwars %>%
  select(gender, mass, height, species) %>% 
  filter(species == "Human") %>% 
  na.omit() %>% 
  mutate(height = height/100) %>% 
  mutate(BMI = mass/height^2) %>%
  group_by(gender) %>% 
  summarise(Average_BMI = mean(BMI))

### Types of Data
#- Understand the five types of data
#- Change the data type for a variable
#- Add "levels" to a factor variable

#Name (Character)
#Height (Factor)
#Age (Integer) whole number
#Weight (Numeric) 

str(starwars) #use this to look at the types of variables 
starwars$height <- as.factor(starwars$height) 
starwars$age <- as.integer(starwars$age) #how to change variables

levels(starwars$height) #looking at the levels 

starwars$height <- factor(starwars$height,
                          levels = c("Short", "Medium", "Tall"))


#Logical variable 
starwars$heavy <- starwars$mass > 23
class(starwars$heavy)

starwars
sw <- starwars %>% 
  select(name, height, mass, gender, everything()) #this will select the variables first

sw <- starwars %>% 
  select(name, mass, height) %>% 
  rename(weight = mass) #changing the name of variables 

starwars

sw1 <- starwars %>% 
  select(name, height, mass, gender) %>% 
  rename(weight = mass) %>% 
  na.omit() %>% 
  mutate(height = height/100) %>% 
  filter(gender %in% c("masculine", "feminine")) %>% 
  mutate(gender = recode(gender, #Change the name of observations
                         masculine = "M",
                         feminine = "F")) %>% 
  mutate(size = height > 1 & weight > 75, #creates a new logical variable called "size"
         size = if_else(size == TRUE, "big", "small"))


View(msleep)
my_data <- msleep %>%
  select(name, sleep_total) %>% 
  filter(sleep_total > 18) #Extracts only observations where sleep was greater than 18

##Same thing but with the "!"
my_data <- msleep %>%
  select(name, sleep_total) %>% 
  filter(!sleep_total > 18) #"!" refers to the opposite or NOT

#Filter using "," which is similar to saying AND. Primates AND bodywt
my_data <- msleep %>% 
  select(name, order, bodywt, sleep_total) %>% 
  filter(order == "Primates", bodywt > 20) #== is actually a question
  
#Filtering using "|" which is similar to OR. Primates OR bodywt > 20
my_data <- msleep %>% 
  select(name, order, bodywt, sleep_total) %>% 
  filter(order == "Primates" | bodywt > 20)
#Filtering for many different options. 
my_data <- msleep %>% 
  select(name, sleep_total) %>% 
  filter(name == "Cow" |
           name == "Dog" |
           name == "Goat")
#Same as above, just more sophsiticated. "%in%" allows for a list of observations
my_data <- msleep %>% 
  select(name, sleep_total) %>% 
  filter(name %in% c("Cow", "Dog", "Horse")) 

my_data <- msleep %>% 
  select(name, sleep_total) %>% 
  filter(between(sleep_total, 16, 18)) #Any observation where sleep total is between the values

my_data <- msleep %>%
  select(name,sleep_total) %>% 
  filter(near(sleep_total, 17, tol = 0.5)) #Any observation within 0.5 of 17.

my_data <- msleep %>% 
  select(name, conservation, sleep_total) %>% 
  filter(is.na(conservation)) #finding all NA values in conservation (is.na)

my_data <- msleep %>% 
  select(name, conservation, sleep_total) %>% 
  filter(!is.na(conservation)) #finding all values that do not have NA (!is.na)


cars
View(cars)

my_age <- 12
your_age <- 14
sum(my_age, your_age)
plot(cars)
hist(cars$speed)
attach(cars)
hist(distance)

summary(cars) #main variables
summary(cars$speed) #using the dolar sign to see variables
class(cars)
class(cars$speed)
length(cars$speed)
unique(cars$speed)
head(cars)
tail(cars)
subset <- cars[3:6,1:2] #extract certain data within cars
?median
median(cars$dist)

new_data <- c(2,4,6,3,NA,9)
median(new_data) #cant calcuate median because of NA
median(new_data, na.rm = TRUE) #removes NA values 








