Working with Rmarkdown
Matthew Toomey
8/14/2022
You can review the markdown file for this lesson here: https://github.com/mbtoomey/Biol_7263/blob/main/Lectures/Lesson3.Rmd

Introduction
Rmarkdown is a valuable tool to organize code, comments, and output for communication and archiving. I encourage you to use this format to work through our lessons and take notes.

Here we will walk through the basics of Rmarkdown. A helpful quick references is available in Rstudio Help > Markdown Quick Reference:
  
  
  
  A more detailed reference is available at the rmarkdown cookbook.

File types
.Rmd is Rstudio’s secific formulation of Markdown (a text rendering language)
.md is the more generic Markdown file type. In RStudio, the intermediate .md files are not (in the default state) preserved.This is the format of your “readme” file on GitHub.
Basic text formatting
headers # to ###### *numbering from options
text
markup
italic *<text>*
  bold-face **<text>**
  subscript ~<text>~
  superscript ^<text>^
  strikethrough ~~<text>~~
  quotations ><text with no closing mark
Spacing
Regular text is single spaced
double spacing sets a line break (or carriage return)
Insert links and images
links
[Dr. Toomey's website](http://mbtoomey.net)
Dr. Toomey’s website

images
![Penguin](Penguin.jpg)

Penguin

Lists
unordered list
- Finches
- Sparrows
    - House sparrow
    - Tree sparrow
For second level list items “-” is preceeded by two spaces

Finches
Sparrows
House sparrow
Tree sparrow
Order lists
1. Finches
2. Sparrows
    - House sparrow
    - Tree sparrow
Finches
Sparrows
House sparrow
Tree sparrow
Fencing
Anything surrounded by backticks `will render as plain text` 
Anything surrounded by backticks will render as plain text

R code inside ticks can be executed during rendering. For example, you can caluclate a value `r 3 + pi`. 
R code inside ticks can be executed during rendering. For example, you can caluclate a value 6.1415927.

You can create a whole block of plain text by surrounding it with three backticks

everything is plain text here.
even single lines

Useful for show blocks of codes
Block quotes with >
> Whether I shall turn out to be the hero of my own life, or whether that station will be held by anybody else, these pages must show.
Whether I shall turn out to be the hero of my own life, or whether that station will be held by anybody else, these pages must show.

Spacer line with three or more underscores
___   
Tables
| Species  | Awesomeness
| :------------- | :-------------
| House Sparrow   | Medium|
| Tree Sparrow  | High|
Species	Awesomeness
House Sparrow	Medium
Tree Sparrow	High
The “-” separates the header from the rest of the column The “:” set the justification

Equations
in-line $

centered $$

basic math and text spacing handled by LateX. Note that this language is a bit different than the basic markdown (e.g. how sub and superscripts are handled)

$$y = a + b$$
y=a+b

Subcripts
$$H_0 = Z_{a + b}$$
H0=Za+b

Superscripts
$$S = cA^z$$
S=cAz

elements can be coupled and nested
S=cAz1+z2+x

$$S=cA^z_1 + z_{2 + x}$$
Fractions and Greek Symbols
α=βδ+γx

$$\alpha = \frac{\beta}{\delta + \gamma_x}$$
Summation signs
z=∑i=1XK

$$z = \sum_{i=1}^X{K}$$
What is you need a backslash in your equation?
Use \backslash

$$\backslash \alpha \le b \backslash$$
∖α≤b∖

Rendering plain text in a LaTex Equation
P(Expressionofgene)=Z

$$P(Expression of gene) = Z$$
P(Expression of gene)=Z

$$P(\mbox{Expression of gene}) = Z$$
R code blocks
initiate with keyboard command ctrl+alt+i
Lnk <-"https://github.com/mbtoomey/Biol_7263/blob/main/Data/yeast.Rdata?raw=true"
download.file(Lnk, "yeast.Rdata", mode = "wb")
load("yeast.Rdata")
This will load a dataframe called yeast that is taken from figure 2 of:

Shen, X., S. Song, C. Li, and J. Zhang (2022). Synonymous mutations in representative yeast genes are mostly strongly non-neutral. Nature:1–7.

We can peek at the data with head(yeast).

head(yeast)
##       Genotype Mutation_type      Fitness
## 1   ADA2-1-G-A Nonsynonymous 0.9906040818
## 2   ADA2-1-G-C Nonsynonymous  0.993975531
## 3  ADA2-10-C-A Nonsynonymous  0.993231198
## 4  ADA2-10-C-G Nonsynonymous  1.002668775
## 5  ADA2-10-C-T    Synonymous  0.996798329
## 6 ADA2-100-A-C    Synonymous 0.9917757698
Explore the data
We can begin to work with the dataset. Lets calculated a mean of fitness

mean(yeast$Fitness)
## Warning in mean.default(yeast$Fitness): argument is not numeric or logical:
## returning NA
## [1] NA
This fails because the data type of Fitness was classified as character. Let’s fix this.

yeast$Fitness<-as.numeric(yeast$Fitness)
## Warning: NAs introduced by coercion
Let’s try agian

mean(yeast$Fitness)
## [1] NA
There are missing vaues in the dataset (NAs) that R doesn’t know what to do with. Let’s get rid of those for now. (Note this might not always be a wise approach!!)

yeast<-na.omit(yeast)
Third time is a charm?

mean(yeast$Fitness)
## [1] 0.9845621
Notice that the results are given immediately after the code block.

As noted abov, Rmarkdown you can also integrate results into you text. For example, we can add the mean of fitness directly to the text by putting in the inline command “r mean(fitness)” surrounded by `

The mean fitness across all mutant genotypes was 0.9845621.

What is cool about this is that this dynamic and is recaculated everytime you “Knit” the markdown. If there are changes to the dataset, they will be incorporated here.

Rmarkdown also allows you include data plots

boxplot(yeast$Fitness ~ yeast$Mutation_type)


What if we want to show the plot, but do not want the reader to see the code? We can add echo = FALSE option to the r call



What if we want to show the code, but do not want run it? We can add eva, = FALSE option to the r call

boxplot(yeast$Fitness ~ yeast$Mutation_type)