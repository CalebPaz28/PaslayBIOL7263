install.packages("spatstat")
install.packages("maptools")
install.packages("lattice")

library(spatstat)
library(maptools)
library(lattice)

#using data on spatial distributions of Japanese Pine, Redwood, and locations of cell centers.

data("japanesepines")
data("redwoodfull")
data("cells")

plot(japanesepines, main = "Japanese Pines", axes = TRUE)
plot(redwoodfull, main = "redwood", axes = TRUE)
plot(cells, main = "cells", axes = TRUE)

#as ppp or point pattern datasets
#"cartesian corrdinates of points in a two-dimensional plane"
#we need the the points in a dataset format = SpatialPoints

spjpines <- as(japanesepines, "SpatialPoints")
spred <- as(redwoodfull, "SpatialPoints")
spcells <- as(cells, "SpatialPoints")

summary(spjpines)#max of 5.7
summary(spred)#max of 1
summary(spcells)#max of 1

#we can see that the pine plot is not the same range as the other 2
plot(spjpines, main = "japanese pines", axes = TRUE)
plot(spred, main = "redwood", axes = TRUE)
plot(spcells, main = "cells", axes = TRUE)


#thankfully we can use the 'elide' method for standardizing SpatialPoints coordinate data scales
spjpines1 <- elide(spjpines, scale=TRUE, unitsq=TRUE)
summary(spjpines1)#now the max = 1

#Now we can set up a comparable data frame
dpp<-data.frame(rbind(coordinates(spjpines1),coordinates(spred), 
                      coordinates(spcells)))
print(dpp)

njap<-nrow(coordinates(spjpines1))
nred<-nrow(coordinates(spred))
ncells<-nrow(coordinates(spcells))

dpp<-cbind(dpp,c(rep("JAPANESE",njap), rep("REDWOOD", nred), rep("CELLS", ncells))) 
names(dpp)<-c("x", "y", "DATASET")

print(dpp)

library(lattice)
print(xyplot(y~x|DATASET, data=dpp, pch=19, aspect=1))

#from the looks of it, redwood seem clustered in a few places, cells seem spaced evenly, and pines seem possibly random

#Testing for Complete Spatial Randomness (CSR)
#G function: Distance to the Nearest Event 
#compares an "envelope" of expected random distribution to the observed data

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
#redwoods show clustered pattern (values of G above the envelopes)
#cells shows a more regular pattern (values of G below the envelopes)

#Second order functions!
#We want to measure strength and types of interactions between points
#K-function measures the number of events found up to a given distance of any particular event 


Kenvjap<-envelope(as(spjpines1, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

Kenvred<-envelope(as(spred, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

Kenvcells<-envelope(as(spcells, "ppp"), fun=Kest, r=r, nrank=2, nsim=99)

Kresults<-rbind(Kenvjap, Kenvred, Kenvcells)
Kresults<-cbind(Kresults, 
                y=rep(c("JAPANESE", "REDWOOD", "CELLS"), each=length(r)))
summary(Kresults)

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

#The shaded envelope represents the null hypothesis of Complete Spatial Randomness 
#Japanese Pines seem to follow CSR while redwood and cells do not.