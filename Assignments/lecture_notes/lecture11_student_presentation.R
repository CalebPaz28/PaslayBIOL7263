snippet ## ---------------------------
##
## Script name: Lecture 11 Bekah (geomorph) and Emily (Phytools)
##
## Purpose of script: Notes and walkthrough
##
## Author: Caleb Paslay
##
## Date Created: 2022-11-17
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## load the packages needed:  

library(RRPP)

install.packages("geomorph", dependencies = TRUE)

library(geomorph)
data("plethodon") #geomorph comes with a salamander dataset

#We can use an photo, it must be jpeg and it should have a scale bar. 

filelist <- list.files(pattern ="*.jpeg")

#select landmarks on your image.

dev.new(noRStudioGD = TRUE)

digitize2d(filelist, nlandmarks = 11, scale = 3, 
           tpsfile = "shrimp.tps", verbose = TRUE)



mydata <- readland.tps("shrimp3.tps", specID= "ID")
#Must use these to plot data
Y.gpa <- gpagen(plethodon$land, print.progress = FALSE)
ref <- mshape(Y.gpa$coords)

# Takes landmark data and plots it (TPS method)
plotRefToTarget(ref, y.gpa$coords[,,39], mag = 3, 
                method = "TPS")

# Vector method
plotRefToTarget(ref, y.gpa$coords[,,39], mag = 3, 
                method = "vector")

#Look at different points
plotRefToTarget(ref, y.gpa$coords[,,39], mag = 3, 
                method = "points") 


gp2 <- gridPar(pt.bg = "green", pt.size = 1)

plotRefToTarget(Ref, y.gpa$coords[,,39], gridPars = GP2, mag = 3, )

#Plotting all the different points

plotAllSpecimens(Y.gpa$coords, links = plethodon$links, label =T, 
                 plot.param = list(pt.bg = "green", mean.cex = 1, 
                                   link.col = "red", txt.pos = 3, 
                                   txt.cex = 1))

#Assignment 

#1. Chose two images of the same animal and compare a morphological feature through landmarking (at least ten landmark points.
#2. Make a plot with either plotAllSpecimens or plotRefToTarget (points, vector, or TPS method)
#3. Upload as "Hansen seminar assignment" 


########################################################################

# Phylogenetic tool that is used for comparative biology

# Represents hypotheses about evolutionary histories

# Node is a speciation event. Nodes can rotate around a branch. 


# base = past and tip = present

# Chronograms incorporate a time scale 

install.packages("phytools")
install.packages("geiger")  
install.packages("diversitree")  
install.packages("mapplots")

packageVersion("ape")

library(phytools)
library(geiger)
library(diversitree)
library(mapplots)

phyo1 <- "((Caudata, Anura), Gymnophiona);"

amphibians <- read.tree(text = phyo1)
plotTree(amphibians, ftype = "reg")

add.arrow(amphibians = NULL, tip = 1, offset = 8) #adding arrow to a plot

# tip is from bottom to top of branches

phylo2<- "(((((((cow, pig),whale),(bat,(lemur,human))),(blue_jay,snake)),coelacanth),gold_fish),lamprey);"

vert_tree<-read.tree(text=phylo2)

#Edge.wdith works with with plot NOT plotTree
plotTree(vert_tree, no.margin =TRUE, edge.width = 1)

roundPhylogram(vert_tree)

plot(vert_tree, edge.color = "purple", label.offset = 0.2, type = "cladogram")


#Plotting and unrooted tree 
#(using unrooted trees within a population of a species)

plot(unroot(vert_tree), type = "unrooted", no.margin = TRUE,
     lab4ut = "axial", edge.width = 2)


Salamanders<- "(((((((Amphiumidae,Plethodontidae),Rhyacotritonidae),((Ambystomatidae,Dicamptodontidae),Salamandridae)),Proteidae)),Sirenidae),(Hynobiidae,Cryptobranchidae));"
Mander.tree<-read.tree(text=Salamanders)
plot(Mander.tree, label.offset = 0.2)

Mander.tree

Mander.tree$tip.label

Ntip(Mander.tree)
Nnode(Mander.tree)

#step to check that the tree is behaving well
plotTree(Mander.tree, offset = 0.5)
tiplabels()
nodelabels()

drop <- drop.tip(Mander.tree, 8)
plot(drop)

#

time_cal <- read.tree("Assignments/Data/time_cal")
plot(time_cal)

time_cal

sally_tree <- read.nexus("Assignments/Data/Bonett_tree")

plot(sally_tree)
tiplabels()
nodelabels()


plotTree(sally_tree, ftype = "i", fsize = .02, lwd = 1)


Ntip(sally_tree)
Nnode(sally_tree)

tips <- sally_tree$tip.label

genera <- unique(sapply(strsplit(tips,"_"), function(x) x[1]))
genera

class(genera)

plot(unroot(sally_tree), type = "unrooted", cex = 0.2,
     use.edge.length = FALSE, lab4ut = "axial", 
     no.margin = TRUE)


plotTree(sally_tree, type = "fan", fsize = 0.2, lwd = 1, ftype = "i")

plotTree(sally_tree, ftype = "i", fsize = 0.2, lwd = 1)


nodelabels()

# Extracting a clade from a larger amount of data

tt674 <- extract.clade(sally_tree, 674) #extracting clade 674

plot(tt674, fsize = 0.8)


geo.palette()

tr<-as.phylo(time_calibrated)

geolegend3<-function(leg=NULL,cols=NULL,alpha=0.2,...){
  if(hasArg(cex)) cex<-list(...)$cex
  else cex<-par()$cex
  if(is.null(cols)){
    cols<-setNames(c(
      rgb(255,242,127,255,maxColorValue=255),
      rgb(255,230,25,255,maxColorValue=255),
      rgb(253,154,82,255,maxColorValue=255),
      rgb(127,198,78,255,maxColorValue=255),
      rgb(52,178,201,255,maxColorValue=255),
      rgb(129,43,146,255,maxColorValue=255),
      rgb(240,64,40,255,maxColorValue=255),
      rgb(103,165,153,255,maxColorValue=255),
      rgb(203,140,55,255,maxColorValue=255),
      rgb(179,225,182,255,maxColorValue=255),
      rgb(0,146,112,255,maxColorValue=255),
      rgb(127,160,86,255,maxColorValue=255),
      rgb(247,67,112,255,maxColorValue=255)),
      c("Quaternary","Neogene","Paleogene",
        "Cretaceous","Jurassic","Triassic",
        "Permian","Carboniferous","Devonian",
        "Silurian","Ordovician","Cambrian",
        "Precambrian"))
  }
  if(is.null(leg)){
    leg<-rbind(c(2.588,0),
               c(23.03,2.588),
               c(66.0,23.03),
               c(145.0,66.0),
               c(201.3,145.0),
               c(252.17,201.3),
               c(298.9,252.17),
               c(358.9,298.9),
               c(419.2,358.9),
               c(443.8,419.2),
               c(485.4,443.8),
               c(541.0,485.4),
               c(4600,541.0))
    rownames(leg)<-c("Quaternary","Neogene","Paleogene",
                     "Cretaceous","Jurassic","Triassic",
                     "Permian","Carboniferous","Devonian",
                     "Silurian","Ordovician","Cambrian",
                     "Precambrian")
  }
  cols<-sapply(cols,make.transparent,alpha=alpha)
  obj<-get("last_plot.phylo",envir=.PlotPhyloEnv)
  t.max<-max(obj$x.lim)
  ii<-which(leg[,2]<=t.max)
  leg<-leg[ii,]
  leg[max(ii),1]<-t.max
  y<-c(rep(0,2),rep(par()$usr[4],2))
  for(i in 1:nrow(leg)){
    polygon(c(leg[i,1:2],leg[i,2:1]),y,col=cols[rownames(leg)[i]],
            border=NA)
    lines(x=rep(leg[i,1],2),y=c(0,par()$usr[4]),lty="dotted",
          col="grey")
    lines(x=c(leg[i,1],mean(leg[i,])-0.8*cex*
                get.asp()*strheight(rownames(leg)[i])),
          y=c(0,-1),lty="dotted",col="grey")
    lines(x=c(leg[i,2],mean(leg[i,])+0.8*cex*
                get.asp()*strheight(rownames(leg)[i])),
          y=c(0,-1),lty="dotted",col="grey")
    lines(x=rep(mean(leg[i,])-0.8*cex*
                  get.asp()*strheight(rownames(leg)[i]),2),
          y=c(-1,par()$usr[3]),lty="dotted",col="grey")
    lines(x=rep(mean(leg[i,])+0.8*cex*
                  get.asp()*strheight(rownames(leg)[i]),2),
          y=c(-1,par()$usr[3]),lty="dotted",col="grey")
    polygon(x=c(leg[i,1],
                mean(leg[i,])-0.8*cex*get.asp()*strheight(rownames(leg)[i]),
                mean(leg[i,])-0.8*cex*get.asp()*strheight(rownames(leg)[i]),
                mean(leg[i,])+0.8*cex*get.asp()*strheight(rownames(leg)[i]),
                mean(leg[i,])+0.8*cex*get.asp()*strheight(rownames(leg)[i]),
                leg[i,2]),y=c(0,-1,par()$usr[3],par()$usr[3],-1,0),
            col=cols[rownames(leg)[i]],border=NA)
    text(x=mean(leg[i,]),y=-1,labels=rownames(leg)[i],srt=90,
         adj=c(1,0.5),cex=cex)
  }
}

plotTree(tr)

plotTree(tr,direction="leftwards",xlim=c(180,-60),
         ylim=c(-3,11),log="x",lwd=1)
geo.legend(alpha=0.3,cex=1.2)
plotTree(tr,direction="leftwards",xlim=c(180,-60),
         ylim=c(-3,11),log="x",lwd=1,add=TRUE)



#1. Create a family level tree with 8 tips in a clade of interest. 
#Make sure they are evolutionarily correct (e.g., sister species).
#2. Change the color of the tree to something besides the default



tt743 <- extract.clade(sally_tree, 743) #extracting clade 743

plotTree(tt743, fsize = 0.8)

nodelabels()

tt173 <- extract.clade()


phylo2<- "(((((((cow, pig),whale),(bat,(lemur,human))),(blue_jay,snake)),coelacanth),gold_fish),lamprey);"
vert_tree<-read.tree(text=phylo2)
plot(vert_tree)


bpev <- "(((BPEV_healey, BPEV_Feher), (BPEV_Marengo2, BPEV_Maor)), (BPEV_IS, BPEV_Kyosuzo), (BPEV_Santa, BPEV_Penol));"
bpev_tree <- read.tree(text =bpev)
plot(bpev_tree)

bpev_plot <- plotTree(bpev_tree, color = "darkred")



# BPEV from this paper
https://apsjournals.apsnet.org/doi/full/10.1094/MPMI-12-17-0312-R


