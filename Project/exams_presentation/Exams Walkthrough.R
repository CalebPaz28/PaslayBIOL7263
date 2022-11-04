install.packages("exams") #First install the exams package

library(exams) #Load the Exams R package

#To create a question we will used individual R markdown documents. 

#General outline for generating a question

Question
========
On what date does the summer solstice occur? 
  
  
answerlist
----------
* June
* July
* August
* May


meta-information
================
exname: Solstice Q
extype: schoice
exsolution: 0100 
exshuffle:4 

#We can then run the function exams2html("Rmd.file") to see how it renders
#We can also use exams2pdf. 

#First we can make a variable containing the questions of interest.
class_exam <- c("question1.Rmd", "question2.Rmd", "question3.Rmd", 
                "question4.Rmd", "question5.Rmd", "question6.Rmd")


set.seed(2022-10) #we use this to generate a random number generator (RNG) state
practice_exam <- exams2nops(class_exam, #variable of files
                            n =1, #number of copies to be be compiled
                            nsamp = NULL, #
                            dir = "nops_pdf", #generates a folder in the current directory
                            name = "class_exam",
                            language = "en", #specify a language output
                            title = "Class Exam 1", 
                            course ="BIOL",
                            institution = "University of Tulsa",
                            logo = NULL, #attach a logo image
                            date = "2022-10-21",
                            blank = 0, #number of blank pages at the end.
                            duplex = FALSE, #should blank pages be added after title
                            pages = NULL, #include a path to additional PDF documents
                            startid = 10, #starting ID for exam numbers
                            points= c(1,1,1,1,1,1), #points assigned to each excercise.
                            showpoints = TRUE, #points achievable for each question
                            samepage = TRUE, #force answers on same page
                            reglength = 7)

                            






write.table(data.frame(
  registration = c("0000013", "0000012"),
  name = c("Caleb Paslay", "Britley Paslay"),
  id = c("caleb_paslay", "britley_paslay")
), file = "Exam-2015-07-29.csv", sep = ";",
quote = FALSE, row.names = FALSE)






  