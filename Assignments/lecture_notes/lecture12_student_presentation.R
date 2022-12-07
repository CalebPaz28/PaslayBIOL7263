snippet ## ---------------------------
##
## Script name: 12.1.22 Student presentations
##
## Purpose of script: Taking notes
##
## Author: Caleb Paslay
##
## Date Created: 2022-12-01
##
##
## ---------------------------
##
## Notes: Making and using Heatmaps (Madison Herrboldt), 
## creating an R package (Elise), analysis of spatial data (Olivia)
##   
##
## ---------------------------

## load the packages needed for heatmaps:  

library(stats)
library(ggplot2)

# Other packages for heatmaps 

#plot_ly(): part of the plotly package
#d3heatmap(): part of the d3heatmap package
#heatmaply(): part of the heatmaply package

####################################################################################################################################

pheremone_data <- read.csv("Assignments/Data/pheromone_data.csv")


#in order to use the heatmap() function, we need to transform the csv file into a numeric data frame
#this also allows us to make sure we keep our rownames

pheremone_data1 <- as.matrix(pheremone_data[,-1])

rownames(pheremone_data1) <- pheremone_data[,1]

heatmap(pheremone_data1)

#More advanced heat map
heatmap(pheremone_data1, 
        Colv = NA, #no column clustering
        Rowv = NA, #no row clustering
        margins = c(7,5),
        cexCol = 1,
        main = "Pheromone gene expression",
        xlab = "Groups",
        ylab = "Gene")

#Changing the color to use "col"

heatmap(pheremone_data1, 
        Colv = NA, #no column clustering
        Rowv = NA, #no row clustering
        margins = c(7,5),
        cexCol = 1,
        col = terrain.colors(10),
        main = "Pheromone gene expression",
        xlab = "Groups",
        ylab = "Gene")

# Using GGplot to create a heatmap
pheremone_data2 <- read.csv("Assignments/Data/pheromone_data2.csv")

ggplot(pheremone_data2,
       aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile()

ggplot(pheremone_data2,
       aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(colour = "black", size = 0.5) + 
  scale_fill_gradient(low = "black", high = "lightgreen") +
  theme_gray(base_size = 12) +
  facet_grid(~Gland, switch = "x", scales = "free_x", space = "free_x") + 
  ggtitle(label = "Pheromone gene expression") +
  scale_x_discrete(labels = c('D.brim', 'E.tyn M', 'E.tyn P', 'P.alb', 'D.brim', 'E.tyn M', 'E.tyn P', 'P.alb')) +
  theme(plot.title = element_text(face = "bold"),
        strip.placement = "outside", 
        legend.title = element_text(face = "bold"),
        axis.title = element_text(face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black"),
        axis.text.x = element_text(angle = 270, hjust = 0, color = "black"),
    axis.ticks = element_blank(),
plot.background = element_blank(),
panel.background = element_blank(),
panel.border = element_blank())

####################################################################################################################################
#Assignment Script

assignment <- read.csv("Assignments/Data/MAH_assignment_data.csv")

View(assignment)

ggplot(assignment,
       aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(colour = "black", size = 0.5) + 
  scale_fill_gradient(low = "black", high = "lightgreen") +
  theme_gray(base_size = 12) +
  facet_grid(~Tissue, switch = "x", scales = "free_x", space = "free_x") + 
  ggtitle(label = "Pheromone gene expression") +
  scale_x_discrete(labels = c('D.brim', 'E.tyn M', 'E.tyn P', 'P.alb', 'D.brim', 'E.tyn M', 'E.tyn P', 'P.alb')) +
  theme(plot.title = element_text(face = "bold"),
        strip.placement = "outside", 
        legend.title = element_text(face = "bold"),
        axis.title = element_text(face = "bold"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black"),
        axis.text.x = element_text(angle = 270, hjust = 0, color = "black"),
        axis.ticks = element_blank(),
        plot.background = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank())


####################################################################################################################################

# Creating your own R package 

#Purpose of an R package is when you will be performing an analysis consistently

install.packages(c("devtools", "roxygen2")) #used for making packages
library(devtools)
library(roxygen2)

create_package("rateLawOrders")

# these following functions must be run while your working directory is set to the package folder (i.e. rateLawOrders in this case)
document() # from devtools package, updates the package's documentation
check() # from devtools package, checks package for errors

# A lot of Elise's lesson was from a different folder because of the way it 
# was used to create an R package. 




##################################################################

install.packages("spatstat")
install.packages("maptools")
install.packages("lattice")

library(spatstat)
library(maptools)
library(lattice)

data("japanesepines")
data("redwoodfull")
data("cells")

summary(japanesepines)

plot(japanesepines, main = "Pines", axes = TRUE)
plot(redwoodfull, main = "Red", axes =TRUE)

spjpines <- as(japanesepines, "SpatialPoints")
spred <- as(redwoodfull, "SpatialPoints")
spcells <- as(cells, "SpatialPoints")

spjpines
summary(spjpines)
summary(spred)

spjpines1 <- elide(spjpines, scale=TRUE, unitsq=TRUE)
summary(spjpines1)#now the max = 1


dpp<-data.frame(rbind(coordinates(spjpines1),coordinates(spred), 
                      coordinates(spcells)))
print(dpp)

njap<-nrow(coordinates(spjpines1))
nred<-nrow(coordinates(spred))
ncells<-nrow(coordinates(spcells))

dpp<-cbind(dpp,c(rep("JAPANESE",njap), rep("REDWOOD", nred), 
                 rep("CELLS", ncells))) 
names(dpp)<-c("x", "y", "DATASET")

print(dpp)

print(xyplot(y~x|DATASET, data=dpp, pch=19, aspect=1))

# Statistical test 
r <- seq(0, sqrt(2)/6, by = 0.001)

envjap <- envelope(as(spjpines1, "ppp"), fun=Gest, r=r, nrank=2, nsim=99)

envred <- envelope(as(spred, "ppp"), fun=Gest, r=r, nrank=2, nsim=99)

envcells <- envelope(as(spcells, "ppp"), fun=Gest, r=r, nrank=2, nsim=99)


Gresults <- rbind(envjap, envred, envcells) 
Gresults <- cbind(Gresults, 
                  y=rep(c("JAPANESE", "REDWOOD", "CELLS"), each=length(r)))
summary(Gresults)

print(xyplot(obs~theo|y, data=Gresults, type="l", 
             panel=function(x, y, subscripts)
             {
               lpolygon(c(x, rev(x)), 
                        c(Gresults$lo[subscripts], rev(Gresults$hi[subscripts])),
                        border="gray", col="gray"
               )
               
               llines(x, y, col="black", lwd=2)
             }
))


# Second order property

Kenvjap<-envelope(as(spjpines1, "ppp"), fun=Kest, r=r, nrank=2, nsim=99) #we are still using the standardized pine plot(spjpines1)

Kenvred<-envelope(as(spred, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

Kenvcells<-envelope(as(spcells, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

Kresults<-rbind(Kenvjap, Kenvred, Kenvcells)

Kresults<-cbind(Kresults, 
                y=rep(c("JAPANESE", "REDWOOD", "CELLS"), each=length(r)))
summary(Kresults)

# Plotting the random distribution of points

print(xyplot((obs-theo)~r|y, data=Kresults, type="l", 
             ylim= c(-.06, .06), ylab=expression(hat(K) (r)  - pi * r^2),
             panel=function(x, y, subscripts)
             {
               Ktheo<- Kresults$theo[subscripts]
               
               lpolygon(c(r, rev(r)), 
                        c(Kresults$lo[subscripts]-Ktheo, rev(Kresults$hi[subscripts]-Ktheo)),
                        border="gray", col="gray"
               )
               
               llines(r, Kresults$obs[subscripts]-Ktheo, lty=2, lwd=1.5, col="black")   
             }
))



