snippet ## ---------------------------
##
## Script name: Student Presentation
##
## Purpose of script: Taking notes from Tanner Mierow and Emily Adamic 
## presentations
## Author: Caleb Paslay
##
## Date Created: 2022-10-27
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## load the packages needed:  

#What is acuity? Resolution the animal can see the world in

#Measured in degrees (Minimum resolvable angles). Smaller is better.

#Why do we care?

#Animal Signals
#Evolutionary drivers 
#Ecological functions of sensory systems (how the animal is using it)


#Optomotor experiments
#Morphological measurements 

#Package(acuityview)
#Photo: photo you wish to alter
#Distance: distance between viewer and object of interest*
#Real width = actual width of the image*
#Eye resolution X = 

library()

#Packages to load
install.packages("AcuityView")
install.packages("magrittr")
install.packages("imager")
install.packages("fftwtools")

library(AcuityView)
library(magrittr)
library(imager)
library(fftwtools)

img <- load.image(file = "hummingbird_1.jpg")
dim(img)

img <- resize(img, 512, 512)
dim(img)

AcuityView(photo = img, 
           distance = 2, 
           realWidth = 2, 
           eyeResolutionX = 8.14, 
           eyeResolutionY = NULL, 
           plot = T, 
           output = "firstimage.jpg")

#MRA --> 1/CPD or visual acuity(VA)

#1. Lynx (lynx lynx)
img2 <- load.image(file="snake_1.jpg")
img2 <- resize(img2, 512, 512)
dim(img2)

AcuityView(photo = img2, 
           distance = 1, 
           realWidth = .1, 
           eyeResolutionX = 0.125, #calculate this resolution by taking 1/(VA)visual acuity
           eyeResolutionY = NULL, 
           plot = T, 
           output = "thirdimage.jpg")

#2. Sea otter (Enhydra lutris)
img1 <- load.image(file = "sea_urchin.jpg")
img1 <- resize(img1, 512, 512)
dim(img1)

AcuityView(photo = img1, 
           distance = 1, 
           realWidth = .01, 
           eyeResolutionX = 0.23, #calculate this resolution by taking 1/(VA)visual acuity
           eyeResolutionY = NULL, 
           plot = T, 
           output = "secondimage.jpg")


#3. Least weasel (Mustela nivalis)
img3 <- load.image(file = "snake_1.jpg")
img3 <- resize(img3, 512, 512)
dim(img3)

AcuityView(photo = img3, 
           distance = .1, 
           realWidth = .01, 
           eyeResolutionX = 0.45, #calculate this resolution by taking 1/(VA)visual acuity
           eyeResolutionY = NULL, 
           plot = T, 
           output = "fourthimage.jpg")

#4. Ghost bat (Macroderma gigas)
img4 <- load.image(file = "snake_1.jpg")
img4 <- resize(img3, 512, 512)
dim(img3)

AcuityView(photo = img4, 
           distance = .1, 
           realWidth = .01, 
           eyeResolutionX = 0.52, #calculate this resolution by taking 1/(VA)visual acuity
           eyeResolutionY = NULL, 
           plot = T, 
           output = "fifthimage.jpeg")

#5. Sheep (Ovis aries)

###################################################################################
#Assignment for aquity view

img <- load.image(file = "Assignments/Images/fish_image.jpeg")
dim(img)

img <- resize(img, 512, 512)
dim(img)

# Eagle
AcuityView(photo = img, 
           distance = 1,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.00714, #take 1/VA (visual aquity) Ex. = 1/140
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/1_m_eagle.jpg") #1 meter

AcuityView(photo = img, 
           distance = 2,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.00714, #take 1/VA (visual aquity) Ex. = 1/140
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/2_m_eagle.jpg") #2 meter

AcuityView(photo = img, 
           distance = 3,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.00714, #take 1/VA (visual aquity) Ex. = 1/140
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/3_m_eagle.jpg") #3 meter

AcuityView(photo = img, 
           distance = 10,  # representing 10 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.00714, #take 1/VA (visual aquity) Ex. = 1/140
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/10_m_eagle.jpg") #10 meter

#Common Ostrich
AcuityView(photo = img, 
           distance = 1,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0505, #take 1/VA (visual aquity) Ex. = 1/19.8
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/1_m_ostrich.jpg") #1 meter


AcuityView(photo = img, 
           distance = 2,  # representing 2 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0505, #take 1/VA (visual aquity) Ex. = 1/19.8
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/2_m_ostrich.jpg") #2 meters


AcuityView(photo = img, 
           distance = 3,  # representing 3 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0505, #take 1/VA (visual aquity) Ex. = 1/19.8
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/3_m_ostrich.jpg") #3 meters


AcuityView(photo = img, 
           distance = 10,  # representing 10 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0505, #take 1/VA (visual aquity) Ex. = 1/19.8
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/10_m_ostrich.jpg") #10 meters


### Mallard Duck
AcuityView(photo = img, 
           distance = 1,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0840, #take 1/VA (visual aquity) Ex. = 1/11.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/1_m_mallard.jpg") #1 meters


AcuityView(photo = img, 
           distance = 2,  # representing 2 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0840, #take 1/VA (visual aquity) Ex. = 1/11.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/2_m_mallard.jpg") #2 meters



AcuityView(photo = img, 
           distance = 3,  # representing 3 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0840, #take 1/VA (visual aquity) Ex. = 1/11.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/3_m_mallard.jpg") #3 meters

AcuityView(photo = img, 
           distance = 10,  # representing 10 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .0840, #take 1/VA (visual aquity) Ex. = 1/11.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/10_m_mallard.jpg") #10 meters




### Canadian Goose
AcuityView(photo = img, 
           distance = 1,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .1041, #take 1/VA (visual aquity) Ex. = 1/9.6
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/1_m_goose.jpg") #1 meters


AcuityView(photo = img, 
           distance = 2,  # representing 2 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .1041, #take 1/VA (visual aquity) Ex. = 1/9.6
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/2_m_goose.jpg") #2 meters

AcuityView(photo = img, 
           distance = 3,  # representing 3 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .1041, #take 1/VA (visual aquity) Ex. = 1/9.6
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/3_m_goose.jpg") #3 meters

AcuityView(photo = img, 
           distance = 10,  # representing 10 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = .1041, #take 1/VA (visual aquity) Ex. = 1/9.6
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/10_m_goose.jpg") #10 meters

### Common Pheasant

AcuityView(photo = img, 
           distance = 1,  # representing 1 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.0775, #take 1/VA (visual aquity) Ex. = 1/12.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/1_m_pheasant.jpg") #1 meters


AcuityView(photo = img, 
           distance = 2,  # representing 2 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.0775, #take 1/VA (visual aquity) Ex. = 1/12.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/2_m_pheasant.jpg") #2 meters


AcuityView(photo = img, 
           distance = 3,  # representing 3 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.0775, #take 1/VA (visual aquity) Ex. = 1/12.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/3_m_pheasant.jpg") #3 meters

AcuityView(photo = img, 
           distance = 10,  # representing 10 meter distance
           realWidth = 0.25, # representing size of object (fish in this case)
           eyeResolutionX = 0.0775, #take 1/VA (visual aquity) Ex. = 1/12.9
           eyeResolutionY = NULL, 
           plot = T, 
           output = "Assignments/Images/10_m_pheasant.jpg") #10 meters
################################################################################

##Loops: Running the same code for different values of a variable. 

#for(index_variable in all_values){Code in here}

for(i in 1:5) {
  t =i +10
  print(i) #simple loop here
}
#Looping character vectors
all_my_favourite_things = c("bikes", "coffee", "brains")

for( one_thing in all_my_favourite_things ) {
  cat("\nI love", one_thing)
}

#conditional statement 
for( one_thing in all_my_favourite_things ) {
  
  if ( one_thing == all_my_favourite_things[ length(all_my_favourite_things) ]  ) {
    cat("\nFinally, I also love", one_thing) 
  } else { 
    cat("\nI love ", one_thing) }
}


#Saving each iteration 
parent_vector <- NULL  

all_values <- c(10, 12, 28, 34)
for (i in all_values){
  
  new_value <- i*2   # run the operation on the current value of i 
  
  parent_vector <- c(parent_vector, new_value)  # add the new value to the end of the parent_vector
  
  cat("\nThis is the parent vector:", parent_vector) # print something out to yourself 
}

#Next (skipping iterations) and Break (stops the loop)

#When you need to run the same code, on many different 
#people/samples/conditions/etc., and you find yourself copy-pasting 
#the same code over and over again.

parent_vector <- NULL  

all_values <- c(10, 12, 28, 34)
for (i in all_values){
  
  new_value <- i*2   # run the operation on the current value of i 
  
  parent_vector <- c(parent_vector, new_value)  # add the new value to the end of the parent_vector
  
  cat("\nThis is the parent vector:", parent_vector) # print something out to yourself 
  file_name = paste0("data_",i, ".png")
  print(file_name)
  ggsave(file_name, width=3)
}


Before putting any code in the loop, make sure you are looping through your variable correctly. You can do this by first just printing out the value of each iteration, with no other code: i.e. for(i in 1:5) { print(i) }

When building, test the internal code on just one iteration, without running the whole loop. You can do this by assigning i=1 in your environment, and running all the code within the loop line-by-line on i=1. If this works, then you can let the loop go on all values of i (i.e. i=1:5)!
  
  Within the loop, have code that prints out messages to yourself. This is you know where the loop is at while it’s going. If it has an error, these messages can also help you notice what step is causing the error.

Add in some conditionals within the loop as error detection… for example, if you know something should be length == 5, then add an if statement (i.e. if length != 5 then break will stop the loop or next will move to the next iteration).

Notice how when you run the loop, things will save to your environment… with each iteration it overwrites these values, so what you see in your environment after the loop has finished is only the LAST iteration.

How do you save things within the loop? CONCATENATE WITH A PARENT VECTOR/DATA FRAME so you can save the results from each iteration.

You can SAVE files/plots to a directory within each loop, using commands such as write.csv() or ggsave(). Remember, you’ll have to create a file_name variable so you can save it with an informative name for each iteration…


all_words = c("bikes", "biology", "coffee", "serendipity")

for(word in all_words){
  
  cat("\n........... Now working on this word:",word, ".......")
  print(word)
  sentence <- paste0("there are", nchar(word),
                     "characters in the word", word,".") #nchar is number of characters in a word
  cat("\n")
  }



all_nums <- c(10,12,28,34,NA,NA,11,11)

even_nums <- NULL
odd_nums <- NULL
for(n in all_nums) {
  
  #if na move to next iteration
  if(is.na(n) == TRUE){
    next}
  #if even store as even if odd store as odd
  if(n %% 2) == 0){
    even_nums <- c(even_nums, n)
    } else{
      oddnums <- c(oddnums, n)
    }
}# end big for loops


all_subs = c("sub_1", "sub_2", "sub_3", "sub_4", "sub_5", "sub_6", "sub_7", "sub_8", "sub_9", "sub_10")

for (sub in all_subs){
  cat("\n.......working on", sub, ".....")
  sub_dir <- paste0("heart_rate_data (1)/")
  cat("\n", sub_dir)
  setwd(sub_dir)
  sub_ref <- ref_df %>% filter (sub==sub)
  
  
  sub.df = NULL
  for(scan in 1:6){
    current_scan_csv <- paste0("scan", scan, ".csv")
    cat("\n", current_scan_csv)
    scan.df <- read.csv(current_scan_csv, header = FALSE)
    scan.df$scan_num = scan
    sub.df <- rbind(sub.df, scan.df)
    scan.df$subject = sub
  }
  sub.df <- read.csv("heart_rate_data (1)/sub_1/scan1.csv", header =FALSE)
  
  head(sub.df)
}

























