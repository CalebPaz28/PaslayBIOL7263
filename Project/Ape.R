snippet ## ---------------------------
##
## Script name: Ape 
##
## Purpose of script:
##
## Author: Caleb Paslay
##
## Date Created: 2022-10-22
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## load the packages needed:  

library(graphics)
library(ape)


mytr <- read.tree(text = "((Pan:5,Homo:5):2,Gorilla:7);")

foo <- function() {
  col <- "green"
  for (i in 1:2)
  axis(i, col = col, col.ticks = col, col.axis = col, las = 1)
  box(lty = "19")
}


layout(matrix(1:4, 2, 2, byrow = TRUE))
plot(mytr); foo()
plot(mytr, "c", FALSE); foo()
plot(mytr, "u"); foo()
par(xpd = TRUE) #Default is FALSE, but will count out data points
plot(mytr, "f"); foo()
box("outer") #makes the most out frame of the figure visable


#1. Compute the node coordinates depending on the type of tree plot, the branch lengths, and other parameters.
#2. Evaluate the space required for printing the tip levels. 
#3. Depending on the options, do some rotation and/or translation. 
#4. Set the limits of the x- and y- axes. 
#5. Open a graphical device and draw an empty plot with the limits found at the previous step. 
#6. Call segments() to draw the branches. 
#Call text() to draw the labels. 

#Step 1 
#The option type specifies the shape of the tree plot:
#5 values are possible: "phylogram", "cladogram", "fan", "unrooted", and "radial"

tr <- compute.brlen(stree(8,"1"), 0.1)
tr$tip.label[] <- ""









