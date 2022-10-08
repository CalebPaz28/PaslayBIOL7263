#Assignment 4 dplyer excercises 

require(tidyverse)

# In which year did I observe the most individual birds? How many?
# Question 1 anwser : 2020 and 3000 were observed. 
# In that year how many different species of birds did I observe?

# In which state did I most frequently observe Red-winged Blackbirds?
# Filter observations for a duration between 5 and 200 minutes. Calculate the mean rate per checklist that I encounter species each year. Specifically, calculate the number of species in each checklist divided by duration and then take the mean for the year.
# Create a tibble that includes the complete observations for the top 10 most frequently observed species. First generate a top 10 list and then use this list to filter all observations. Export this tibble as a .csv file saved to a folder called “Results” folder within your R project and add link to the markdown document.

#loading the data from the website link
MBT_ebird2.csv <- read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true")

MBT_ebird2.csv
#I wanted to isolate the variables of choice given question 1
ebird_cut1 <- select(MBT_ebird2.csv, c(year,count))

ebird_cut1
#I then arranged the data so that the highest count would be given first
ebird_cut1_arranged <- arrange(ebird_cut1, by = desc(count))

ebird_cut1_arranged

glimpse(ebird_cut1_arranged)

MBT_ebird2.csv
glimpse(MBT_ebird2.csv)
colnames(MBT_ebird2.csv)


ebird_cut2 <- select(MBT_ebird2.csv, c(year, count_tot))
ebird_cut2
arrange(ebird_cut2, by = desc(count_tot))
glimpse(ebird_cut2)

ebird_filter1 <- filter(ebird_cut2, year == 2020)
ebird_filter1

## I am stuck here with trying to figure out the number of different species observed. 

MBT_ebird2.csv
colnames(MBT_ebird2.csv)

ebird_select2 <-select(MBT_ebird2.csv, c(location, common_name))
ebird_select2

ebirdfilter2 <- filter(ebird_select2, common_name == "Red-winged Blackbird")
ebirdfilter2


MBT_ebird2.csv %>% 
  select(c(location, common_name)) %>%
  filter(common_name == "Red-winged Blackbird") %>%
  group_by(location) %>%
  summarize(count = n()) %>%
  filter(count == max(count))
  
MBT_ebird2.csv %>%
  select(c(duration, common_name, year, count)) %>%
  arrange(by = duration, count) %>%
  filter(duration >= 5) %>%
  filter(duration <= 200) 
  
#####





