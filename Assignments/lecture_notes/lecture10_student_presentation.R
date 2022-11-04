snippet ## ---------------------------
##
## Script name: Amy West and Cari Lewis Class Presentations
##
## Purpose of script: For notes and practicing 
##
## Author: Caleb Paslay
##
## Date Created: 2022-11-03
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

#Generalized linear model (GLM), Y = X + B format
# Regression model

#Bird banding data

#glm(formula, data, family = gaussian, ...) #general code structure


banding <- read.csv("Assignments/Data/SD_banding_data.csv")

glm_example <- glm(mass~tarsus+wing, data=banding, family=gaussian)
glm_example
summary(glm_example)
anova(glm_example, test = "F")

#LM function outputs the same as GLM but can't specify family

#Will only drop NA's as necessary
#Will keep individual with missing info, if the info is not needed for the model

install.packages("MuMIn")
install.packages("")

library(MuMIn)


#Why is this important?
AIC can help sort out relavant variables. In many case there are lots of variables
within a dataset. 

#Types of information criterion
AIC = 2k - 2ln(L) #requires large sample sizes. (Akaike information cirterion)

#Preferred-safe option
AICc = AIC + 2k^2 + 2k/ n-k-1 #(Akaike information cirterion corrected)


BIC, DIC, WAIC - used mostly for Bayesian analysis. 

#When you have multiple models

#Must remain the same
-input data
-dependent variable
-family (guassian)

#Can change from model to model
-independent variable

A single AIC score is meaningless
  interpretation is in comparison to scores from other model
  
Lower AIC scores are better

size of the number does not matter; more complex models have higher AICc

Differences between 2 or 6 indicates significance

#working backwards
-Start with a model that includes all your variable
-Eliminate variables to see if they improve AICc

#Forwards
-start with a null model
-Keep adding variables to see if it improves AICc


install.packages("MuMIn") 

#Stands for Multi-Model Inference
#Calculates AICc scores
#Automated model generation

install.packages("AICcmodavg") 

#stands for AICc model averaging
#Does other things, but we will primarily use it to make pretty AIC tables

library(MuMIn)
library(AICcmodavg)

?AICcmodavg
AIC(glm_example) #built into R
AICc(glm_example) #added with the packages above

banding_na <- na.omit(banding)

mass_model <- glm(mass~tarsus*wing+fat+species, data = banding_na, 
                  family = gaussian, na.action = na.fail)

AICc_models <- dredge(mass_model, 
                      rank = "AICc",
                      fixed = "species")

View(AICc_models)

model_list <- get.models(AICc_models, subset = 1:5)

model_list[1]

madavg_table <- aictab(model_list, scond.ord= TRUE,
                       sort = TRUE)
madavg_table

#Trick: create a list of model names
model_name_list<-NULL #make an empty list

for (i in 1:5){
  model_name_list = c(model_name_list, as.character(model_list[[i]][['formula']]))
} #loop through model output to extract formula for each model

model_name_list

model_name_listb <- model_name_list[seq(3, length(model_name_list), 3)] #select every third element from list and put it in a new list

model_name_listb

madavg_table <- aictab(model_list, scond.ord= TRUE,
                       sort = TRUE,
                       modnames = model_name_listb)

View(madavg_table)

################################################################################
Uderstanding PCA (Laci Cartmell) 
Principal components analysis is a statistical test that reduces dimensionality
while preserving variance by linearly transforming data into new coordinate system.

install.packages("ggfortify")
install.packages("devtools")
install.packages("remotes") 
install.packages("rgl")
install.packages("pca3d")

# Iris dataset - 3 species, 50 samples each
iris
summary(iris)

#create factor
group_species <- factor(iris$Species,
                        levels = c("versicolor","virginica","setosa"))

summary(group_species)

#Check correlation 
round(cor(iris[,1:4]), 2)

#PCA
iris_pca <- prcomp(iris[,1:4],
                   center = TRUE,
                   scale. = TRUE,
                   cor = TRUE,
                   scores =TRUE)

summary(iris_pca)

iris_pca

## Plotting
library(ggfortify)

# plotting our PC component
iris_pca_plot <- autoplot(iris_pca,
                          data = iris,
                          colour = "Species")

iris_pca_plot

#Screeplot - how many PCA's to keep

iris_pca_scree <- plot(iris_pca, type = "lines")

#biplot
iris_pca_biplot <- biplot(iris_pca)

## 3 DIMENSIONAL
library(pca3d)

pca3d(Iris_pca, group=group_species)
pca3d(Iris_pca, components = 1:3, group=group_species)

#visualize with interactive plot
snapshotPCA3d(file="first3pcs.png")

#create figure for saving
pca2d(Iris_pca, group=group_species, legend="topright")

#another way to create 3d plot

iris_pca <- princomp(iris[,1:4],
                     center = TRUE,   # mean of 0
                     scale. = TRUE,   # STD of 1 
                     cor=TRUE,
                     scores=TRUE))

library(rgl)
#interactive 3d graph
plot3d(iris_pca$scores[,1:3])

text3d(iris_pca$scores[1:3],
       texts=rownames(iris),
       col = "red")

text3d(iris_pca$loadings[,1:3],
       texts=rownames(iris_pca$loadings),
       col ="red")

coords <- NULL

for (i in 1:nrow(iris_pca$loadings)) {
  coords <- rbind(coords, rbind(c(0,0,0),
                                iris_pca$loadings[i,1:3]))
}



library(readxl)

cartmell_NLCD_rlesson <- read_excel("Assignments/Data/Cartmell_NLCD_Rlesson.xlsx")




