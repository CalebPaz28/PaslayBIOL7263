snippet ## ---------------------------
##
## Script name: Cari Lewis presentation
##
## Purpose of script:
##
## Author: Caleb Paslay
##
## Date Created: 2022-11-10
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## load the packages needed:  

library(tidyverse)
library(ggplot2)


#Load tidyverse


#general structure of a function
function_name <- function(arg_1, arg_2, ...) {
  Function body 
}




#function that takes a name as input
new_function_name <- function(my_name){
  print(paste0("My name is ", my_name))
}

new_function_name("Caleb")

# multiple variables (arguments)

pow <- function(x, y){
  result <- x^y
  print(paste(x, "raised to the power of", y, "is", result))
}

pow(8,2) #unnamed arguments 


pow(y = 8, x = 2) #named arguments 

pow(2, x = 8)


mpg
#Using the mpg dataset (complex example)

av_mpg <- function(MANU, MODEL, YEAR){
  man <- filter(mpg, manufacturer == MANU)
  mod <- filter(man, model == MODEL)
  year <- filter(mod, year == YEAR)
  year <- mutate(year, avgmpg = ((cty+hwy)/2))
  write_csv(year, "avgmpg_data.csv")
}


av_mpg("audi", "a4", "1999")


av_mpg("toyota", "camry", "2008")

############# Problem 1 

MBT_ebird <- read_csv(file = "Assignments/Data/MBT_ebird.csv")

# I used Cari's notes. I had a difficult time figuring out how to write the function.
name_function <- function(BIRD){
  name <- filter(MBT_ebird, scientific_name == BIRD) 
  file_name <- paste0(sub(" ", "_", BIRD),".csv") # create the file name variable# creating the body of the function
  write_csv(name, file_name) # write the output csv file
  cat("File", file_name,"created.") # confirm the function output the final listprint()
}

name_function("Anser caerulescens")
name_function("Spatula discors")
name_function("Anas platyrhynchos")



#Problem 2
#Write a second function that will take a file name as input and output the data 
#when that species was observed the most AND the least for each of the files created in Problem 1. 
#Save the output into a single file in your results folder and include the link in your R Markdown file.
#Your ouput file should look like this:

write_csv(head(bird_list,0), "max_min_bird.csv", col_names = TRUE)

max_min <- function(FILE_NAME){ #input is a csv file. 
  bird <- read_csv(FILE_NAME)
  bird_list <- head(arrange(bird, by = desc(count)),1)
  bird_list <- rbind(bird_list, head(arrange(bird, by = count),1))
  write_csv(bird_list, "Max-min_Bird_Obs.csv", col_names = F, append = TRUE)
  cat(FILE_NAME, " added to output .csv file.")
}

max_min("Anas_platyrhynchos.csv")


#Problem 3
#Write a nested function that will complete Problems 1 and 2 
#in a single function, 
#but with the following species names as argument values:

nest <- function(SPECIES){
  b <- filter(MBT_ebird, scientific_name == SPECIES) # create the body of the function
  file_name <- paste0(sub(" ", "_", SPECIES),".csv") # create the file name variable
  write_csv(b, file_name) # write the output csv file
  cat("File", file_name,"created.") # confirm the function output the final list
  bird <- read_csv(file_name) # read the csv to a new variable
  bird_list <- head(arrange(bird, by = desc(count)),1) # find the 
  bird_list <- rbind(bird_list, head(arrange(bird, by = count),1))
  write_csv(bird_list, "Max-min_Bird_Obs-P3.csv", col_names = F, append = TRUE)
  cat(file_name, " added to output .csv file.")
}

nest("Anser caerulescens")
nest("Spatula discors")
nest("Anas platyrhynchos")


nest2 <- function(LOCAL){
  c <- filter(MBT_ebird, location == LOCAL)
  file_name1 <- paste0(sub(" ", "_", LOCAL), ".csv")
  write_csv(c, file_name1)
  cat("File", file_name1, "created.")
  bird <- read_csv(file_name1)
  bird_list <- head(arrange(bird, by = desc(count)), 1)
  bird_list <- rbind(bird_list, head(arrange(bird, by = count),1))
  write_csv(bird_list, "max_min_bird_obs_p3.csv", colnames = F, append = TRUE)
  cat(file_name1, "added to output .csv file.")
}

nest2("US-OK")






