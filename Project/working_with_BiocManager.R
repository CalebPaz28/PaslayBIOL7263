snippet ## ---------------------------
##
## Script name: Bioconductor Package 
##
## Purpose of script:
##
## Author: Caleb Paslay
##
## Date Created: 2022-10-28
##
##
## ---------------------------
##
## Notes: 
##  https://bioconductor.org/packages/devel/bioc/vignettes/msa/inst/doc/msa.pdf 
##
## ---------------------------

## load the packages needed:  
library(Biobase) #many tools for bioinformatics
library(BiocManager) #many tools for bioinformatics
library(msa) #multiple sequence alignment 



mySequenceFile <- system.file("examples", "exampleAA.fasta", package="msa")
mySequences <- readAAStringSet(mySequenceFile)
mySequences

myFirstAlignment <- msa(mySequences) #default is ClustalW alignment program

#Show the complete alignment made
print(myFirstAlignment, show="complete")

#Add features to the alignment of the input
msaPrettyPrint(myFirstAlignment, output="pdf", showNames="none",
               showLogo="none", askForOverwrite=FALSE, verbose=FALSE) #saves the alignment


msaPrettyPrint(myFirstAlignment, y=c(164, 213), output="asis",
               showNames="none", showLogo="none", askForOverwrite=FALSE)

#When calling the "msa" package, clustalW is the default algorithm used. We can change this.

myClustalWAlignment <- msa(mySequences, "ClustalW") #ClustalW
msaClustalW(mySequences) #also written this way
print(myClustalWAlignment)

myClustalOmegaAlignment <- msa(mySequences, "ClustalOmega") #ClustalOmega
msaClustalOmega() #also written this way
print(myClustalOmegaAlignment, show = "complete")

myMuscleAlignment <- msa(mySequences, "Muscle")
msaMuscle(mySequences) #also written this way
myMuscleAlignment

#Using the print function for multiple sequence alignments
help("print,MsaDNAMultipleAlignment-method")

#Printing the results
print(myFirstAlignment, show="alignment")
print(myFirstAlignment, show="alignment", showConsensus=FALSE)
print(myFirstAlignment, show=c("alignment", "version"))
print(myFirstAlignment, show="standardParams")
print(myFirstAlignment, show="algParams")
print(myFirstAlignment, show=c("call", "version"))
print(myFirstAlignment, show="complete")
print(myFirstAlignment, showConsensus=FALSE, halfNrow=3)
print(myFirstAlignment, showNames=FALSE, show="complete")

#Print results with costum consensus sequence
print(myFirstAlignment, show="complete", type="upperlower", thresh=c(50, 20))

#Showing the params
params(myFirstAlignment)

myMaskedAlignment <- myFirstAlignment
colM <- IRanges(start=1, end=100)
colmask(myMaskedAlignment) <- colM
myMaskedAlignment

unmasked(myMaskedAlignment)

conMat <- consensusMatrix(myFirstAlignment)
dim(conMat)

conMat[, 101:110]


conMat <- consensusMatrix(myMaskedAlignment)
conMat[, 95:104]


printSplitString <- function(x, width=getOption("width") - 1)
{
  starts <- seq(from=1, to=nchar(x), by=width)
  for (i in 1:length(starts))
    cat(substr(x, starts[i], starts[i] + width - 1), "\n")
}
printSplitString(msaConsensusSequence(myFirstAlignment))

printSplitString(msaConsensusSequence(myFirstAlignment, type="upperlower",
                                      thresh=c(40, 20)))


data(BLOSUM62)
msaConservationScore(myFirstAlignment, BLOSUM62)

msaConservationScore(myFirstAlignment, BLOSUM62, gapVsGap=0,
                     type="upperlower", thresh=c(40, 20))



#This package can interface with other sequence alignment packages.
hemoSeq <- readAAStringSet(system.file("examples/HemoglobinAA.fasta",
                                       package="msa"))


hemoAln <- msa(hemoSeq)
hemoAln
hemoAln2 <- msaConvert(hemoAln, type="seqinr::alignment")

library(seqinr)
d <- dist.alignment(hemoAln2, "identity")
as.matrix(d)[2:5, "HBA1_Homo_sapiens", drop=FALSE]


library(ape)
hemoTree <- nj(d)
plot(hemoTree, main="Phylogenetic Tree of Hemoglobin Alpha Sequences")


msaPrettyPrint(myFirstAlignment, output="pdf", y=c(164, 213),
               subset=c(1:6), showNames="none", showLogo="none",
               consensusColor="RedGreen", showLegend=FALSE,
               askForOverwrite=FALSE)



msaPrettyPrint(myFirstAlignment, output="pdf", y=c(164, 213),
               subset=c(1:6), showNames="none", showLogo="top",
               logoColors="standard area", shadingMode="similar",
               showLegend=FALSE, askForOverwrite=FALSE)


msaPrettyPrint(myFirstAlignment, output="pdf", y=c(164, 213),
               showNames="none", shadingMode="similar",
               shadingColors="blues", showLogo="none",
               showLegend=FALSE, askForOverwrite=FALSE)

#Showing a legend
msaPrettyPrint(myFirstAlignment, output="pdf", y=c(164, 213),
               showNames="none", shadingMode="similar",
               shadingColors="blues", showLogo="none",
               showLegend=TRUE, askForOverwrite=FALSE)


msaPrettyPrint(myFirstAlignment, output="pdf", y=c(164, 213),
               subset=c(1:6), showNames="none", showLogo="none",
               consensusColor="ColdHot", showLegend=TRUE,
               shadingMode="similar", askForOverwrite=FALSE,
               furtherCode=c("\\defconsensus{.}{lower}{upper}",
                             "\\showruler{1}{top}"))

#This is how you could apply the alignment to a Knitr document. 
<<AnyChunkName,results="asis">>=
  msaPrettyPrint(myFirstAlignment, output="asis")


chunkSize <- 300 ## how much fits on one page depends on the length of
## names and the number of sequences;
## change to what suits your needs
for (start in seq(1, ncol(aln), by=chunkSize))
{
  end <- min(start + chunkSize - 1, ncol(aln))
  alnPart <- DNAMultipleAlignment(subseq(unmasked(aln), start, end))
  msaPrettyPrint(x=alnPart, output="pdf", subset=NULL,
                 file=paste0("aln_", start, "-", end, ".pdf"))
}


toBibtex(citation("msa"))

