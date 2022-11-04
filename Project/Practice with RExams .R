library("exams")


elearn_exam <- c("swiss_1.Rmd", "swisscap.Rmd", "countries.Rmd")

set.seed(2020-03-15)
rxm <- exams2openolat(elearn_exam, n=3,
                    name = "R-exams")




library("exams")
myexam <- c("swiss_1.Rmd", "swisscap.Rmd", "countries.Rmd")

set.seed(2022-10)
practice_exam <- exams2nops(myexam, n =2,
                            dir = "nops_pdf",
                            name = "demo",
                            date = "2022-10-21",
                            points= c(1,1,2), 
                            showpoints = TRUE,
                            duplex = FALSE)



dir("nops_pdf")


img <- dir(system.file("nops", package = "exams"),
           pattern = "nops_scan", 
           full.names = TRUE)
dir.create("nops_scan")
file.copy(img, to ="nops_scan")

nops_scan(dir = "nops_scan")

dir("nops_scan")

library(exams)
?nops_scan

write.table(data.frame(
  registration = c("0000013", "0000012"),
  name = c("Caleb Paslay", "Britley Paslay"),
  id = c("caleb_paslay", "britley_paslay")
), file = "Exam-2015-07-29.csv", sep = ";",
quote = FALSE, row.names = FALSE)

library(readr)
Exam_2015_07_29 <- read_csv("Exam-2015-07-29.csv")
View(Exam_2015_07_29)

evaluatation <- read_csv("nops_eval.csv")
View(evaluatation)

ev1 <- nops_eval(
  register = "Exam-2015-07-29.csv",
  solutions = "nops_pdf/demo.rds",
  scan = Sys.glob("nops_scan/nops_scan_20221023003218.zip"),
  eval = exams_eval(partial = FALSE, negative = FALSE),
  interactive = TRUE)

evaluatation <- read_csv("nops_eval.csv")
View(evaluatation)



dir()





