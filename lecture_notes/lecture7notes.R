snippet ## ---------------------------
##
## Script name: Lecture 7 Beyond bar graphics 10.13.22
##
## Purpose of script:
##
## Author: Caleb Paslay
##
## Date Created: 2022-10-13
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## load the packages needed:  

library(tidyverse)
library(ggplot2)

mpg
#make car class a factor and specify the order of the factor
mpg_fact <- mpg %>%
  mutate(class = factor(class, levels = c("2seater", "subcompact", "compact", "midsize", "minivan", "pickup", "suv")))

glimpse(mpg_fact)

#traditional bar plot of the means and standard error

p1<- ggplot(mpg_fact, aes(x = class, y = hwy)) +
  stat_summary(fun = mean,
               geom = "col",
               width = 0.5,
               color = "red", fill = "white") +
  stat_summary(geom = "errorbar", # by default geom_errorbar will calculate a mean and SE
               width = 0.3) +
  ylim(0,45)+
  coord_flip()
p1

# Boxplot will give us more information about the data.
p2 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_boxplot(color = "red", fill = "white") +
  ylim(0,45) +
  coord_flip()
p2

# Violin plots - show density of data points 
p3 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) + 
  stat_summary(fun = mean, 
               geom = "crossbar",
               width = 0.4, color = "red") +
  ylim(0,45) +
  coord_flip()
p3

p4 <- ggplot(mpg_fact, aes(class, hwy)) +
  geom_jitter(width = 0.3, 
              alpha = 0.4, size = 1.6) + 
  stat_summary(fun = mean, 
  geom = "crossbar",
  width = 0.4, color = "red") +
  stat_summary(geom = "errorbar",
               width = 0.3,
               color = "red") +
  ylim(0,45) +
  coord_flip()
p4

library(patchwork)
(p1 + p2) / (p3 + p4)


# plot points and violin in the same plot 

p5 <- ggpplot(mpg_fact, aes(class, hwy)) +
  geom_violin(position = position_nudge(x = 0.5, y =0),
              width = 0.4)) +
  geom_jitter(width = 0.3, 
              alpha = 0.4, size = 1.6) +
  stat_summary(fun = mean, 
               geom = "crossbar",
               width = 0.4, color = "red") + 
  stat_summary(geom = "errorbar",
               width = 0.3, 
               color = "red") + 
  ylim(0,45) +
  coord_flip()
p5


ID<-c("A","B","C","D","E","F","G","A","B","C","D","E","F","G")
Obs<-c("before","before","before","before","before","before","before","after","after","after","after","after","after","after")
Measure<-c(runif(1:7),runif(1:7)*4)

RepEx<-tibble(ID,Obs,Measure) #make these observations into a tibble


RepEx<-RepEx %>% 
  mutate(Obs = factor(Obs, levels = c("before","after"))) #order the levels of observation as a factor

# build a point and line plot
p6<-ggplot(RepEx, aes(Obs, Measure))+
  geom_point(alpha = 0.4, 
             size = 4, 
             aes(color = ID))+
  geom_line(size = 2, 
            alpha = 0.4, 
            aes(color = ID,  group = ID)) #group the line aesthetic to connect before and after observations by ID
p6




p7<- ggplot(RepEx, aes(x = obs, y = Measure)) +
  stat_summary(fun = mean,
               geom = "col",
               width = 0.5,
               color = "red", fill = "white") +
  stat_summary(geom = "errorbar", 
               width = 0.3) +
p7



















































