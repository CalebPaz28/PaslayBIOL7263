library(tidyverse)
library(dplyr)

part_1 <- read_csv(file = "Assignments/Data/assignment6_part1.csv")

colnames(part_1)
glimpse(part_1)
View(part_1)




part_2 <- read_csv(file = "Assignments/Data/assignment6_part2.csv")

colnames(part_2)
glimpse(part_2)
View(part_2)


#Notes from youtube
library(tidyverse)
?pivot_longer

pivot_longer(cols = 2:8, #which columns are we selecting
             names_to = "age", #creating a new name for the columns
             values_to = "Circ") #the cells of the table






