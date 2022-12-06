library(tidyverse)
library(ggplot2)
library(dplyr)

part_1 <- read.csv("https://raw.githubusercontent.com/mbtoomey/Biol_7263/main/Data/assignment6part1.csv")
colnames(part_1)
glimpse(part_1)
View(part_1)

part_1_1 <-  pivot_longer(part_1, cols = 2:21, names_to = c("sample_id", "sex", "test"), 
                          names_sep = "_")

part_1_2 <- pivot_wider(part_1_1, names_from = ID, values_from = value)

write.csv(part_1_2, file = "Assignments/Data/part1_pivot.csv")

# Just messing with the data now that it is in a tidy format.
part1_plot <- ggplot(part_1_1, aes(x = sex, y = value, col = sex)) +
  geom_point() +
  theme_bw()
part1_plot


part_2 <- read_csv(file = "https://raw.githubusercontent.com/mbtoomey/Biol_7263/main/Data/assignment6part2.csv")

part2_1 <- pivot_longer(part_2, cols = 2:17, 
                        names_to = c("sample_id", "test"), 
                        names_sep = "\\.")  #\\ are needed for R to recognize the period (thanks Amy!)

part_2_2 <- pivot_wider(part2_1, names_from = ID, values_from = value)
        
write.csv(part_2_2, file = "Assignments/Data/part_2_pivot.csv") 

## Merging data (trying inner join)
part_1_2 %>% 
  inner_join(part_2_2, by = c("sample_id", "test")) %>% 
  View() # I was able to merge, but could not figure out how to keep, 
# Sample 1 and Sample 2 in the final merge. 


# Merging data (using full join function)
part_1_2 %>% 
  full_join(part_2_2, by = c("sample_id", "test")) %>% 
  write_csv(file = "Assignments/Data/tidy_data.csv")


### Creating a new tibble with more information

tidy_data <- read_csv(file = "Assignments/Data/tidy_data.csv")

tidy_data %>% 
  mutate(residual_mass = mass / body_length) %>% 
  select(test, sex, residual_mass) %>% 
  group_by(test) %>%
  summarize(mean_mass=mean(residual_mass, na.rm=TRUE), #removing NA's is important here.
            SD_mass=sd(residual_mass, na.rm=TRUE)) %>% 
  write.csv("Assignments/Data/mean_&_SD.csv")
 
  # I could not get the summarize function to work. 
        #Using some of Cari's notes I was able to get it worked out.




###############################################################################

#Notes from youtube

# Ground rules
# R prefers one format
# Tidy data (each variable is in its own column)
# Each observation is in its own row



library(tidyverse)

#Long data into wide data
?pivot_wider
?Orange
View(Orange) #dataset in R
names(Orange)

Orange2 <- Orange %>% 
  pivot_wider(names_from = "age", 
              values_from = "circumference") 
 

# Wide data into long data
?pivot_longer

Orange2 %>% 
  pivot_longer(cols = 2:8,
               names_to = "AGE",
               values_to = "CIRC")

View(Orange2)

pivot_longer(cols = 2:8, #which columns are we selecting
             names_to = "age", #creating a new name for the columns
             names_sep = "-", #we can use this to tell the pivot function how to break up the columns
             values_to = "Circ") #the cells of the table






