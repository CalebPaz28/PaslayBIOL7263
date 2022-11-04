In which year did I observe the most individual birds? How many?
In that year how many different species of birds did I observe?
In which state did I most frequently observe Red-winged Blackbirds?
Filter observations for a duration between 5 and 200 minutes. Calculate the mean rate per checklist that I encounter species each year. Specifically, calculate the number of species in each checklist divided by duration and then take the mean for the year.
Create a tibble that includes the complete observations for the top 10 most frequently observed species. First generate a top 10 list and then use this list to filter all observations. Export this tibble as a .csv file saved to a folder called “Results” folder within your R project and add link to the markdown document.



library(readr)
MBT_ebird <- read_csv("PaslayBIOL7263/Assignments/Data/MBT_ebird.csv")
View(MBT_ebird)

glimpse(MBT_ebird)
#Question 1 solution (2020 and 3154 birds were observed.)
ebird_cut1 <- MBT_ebird %>% 
  select(year, count_tot, count)

ebird_cut1 %>% 
  arrange(desc(by =count_tot))
View(ebird_cut1)

#Question 2 solution (745)
ebird_cut2 <- MBT_ebird %>% 
  select(year, count_tot, count, scientific_name) %>%
  arrange(desc(by = count_tot)) %>% 
  filter(year == 2020, na.omit = TRUE) %>%
  summarise(year, scientific_name) #I scrolled to the bottom to see how many different species were present. 

View(ebird_cut2)

#Question 3 Solution (US-OK and count of 100).
ebird_cut3 <- MBT_ebird %>% 
  select(location, common_name, count) %>% 
  filter(common_name == "Red-winged Blackbird") %>% 
  arrange(by = desc(count)) %>% 
  group_by(location)
ebird_cut3

View(ebird_cut3)
glimpse(ebdird_cut3)

#Question 4 Solution 
glimpse(MBT_ebird)
ebird_cut4 <- MBT_ebird %>% 
  select(year, duration, count_tot) %>% 
  filter(duration > 5, duration < 200) %>% 
  mutate(number_year = count_tot / year) %>%
  group_by(year) %>% 
  summarise(mean(number_year)) #apply a calculation of some kind to the grouped variable.

 write_csv(ebird_cut4, file = "PaslayBIOL7263/mean_num.csv")
?write_csv
?group_by

View(ebird_cut4)

glimpse(MBT_ebird)
#Question 5 (tibble )
ebirdcut_5 <- MBT_ebird %>% 
  select(common_name, scientific_name, count, count_tot) %>% 
  arrange(desc(count_tot)) %>% 
head(10)


tibble_ebirdcut5<- as_tibble(ebirdcut_5)

write_csv(ebirdcut_5, "Data/ebirdcut_5.csv")

ebirdcut_5

tibble_ebirdcut5



  