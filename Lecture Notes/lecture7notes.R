

#10.6.22 Lecture 7

#Introduction to ggplot

#data - a data frame or tibble
#aesthetic mappings (aes) - specify the variables to be plotted
#geom - specify the geometric to be drawn in the layer (e.g. points, lines, bars, etc.)
#stat - compute and plot statisitcal transforms of the raw date
#position - adjustments for overlapping elements
#facet - generate multiple related plots

library(tidyverse)
library(ggthemes)
library(patchwork)

install.packages(c("ggthemes","patchwork"))

# generic ggplot template
# p1 <- ggplot(data = <Data>, mapping = aes(<Mapping>)) +
# <geom_function> (aes(<mappings>)), stat=<stat>,
# position=<POSITION>) +
# theme(<axes, font, etc.>) + <coordinate_function> +
# <facet_function>

#Control + Shift + C (coverts all highlighted text to commented text)

#p1 to output you have to call the ggplot object
#ggsave(plot=p1, filename="myplot", width=5, height=3, units = "in", device = "svg")

#Quick plotting - qplot function

mpg

#generate simple histogram with qplot
qplot(x=mpg$cty)

#add color
qplot(x=mpg$cty, fill=I("goldenrod"), color=I("black")) #I is for identity
# fill - color of bar and color - line color of plotted data 

#Trial
qplot(x=mpg$cty, fill= mpg$trans)
#Trial
qplot(x=mpg$cty, color= mpg$trans)

qplot(x=mpg$cty, geom = "density")

#Simple scatter plot with regression line
qplot(x=mpg$cty, y=mpg$hwy, geom=(c("point", "smooth")), method = "lm")


#color points by variable
qplot(x=mpg$cty, y=mpg$hwy, color = mpg$class, geom = "point")

#regression is not applied to each class
qplot(x=mpg$cty, y=mpg$hwy, color = mpg$class, geom = c("point","smooth"), method="lm")


#Basic boxplot
qplot(x = mpg$fl, y = mpg$cty, geom="boxplot", fill = I("red"))
#Basic barplot
qplot(x = mpg&fl, geom = "bar")

#barplot with specified means
mpg_summary <- mpg %>%
  group_by(class) %>%
  summarise(mean_hwy = mean(hwy))

p<- qplot(x=mpg_summary$class, y=mpg_summary$hwy, geom="col")
p

#we can flip coordinates with coord_flip()
p + coord_flip()

##################################################################
#Full ggplots 
#themes and fonts

p1 <- ggplot(data=mpg, mapping=aes(x=hwy,y=cty)) + geom_point()
p1
# a more concise way to write the same code
p_concise <- ggplot(mpg, aes(hwy,cty))+geom_point(color="green")
p_concise

#default theme is a grey background with no axes

#we can change this by layering themes onto it

p1+theme_bw() #adds black outline to the plot 
p1+theme_classic() #basic plot as well
p1+theme_dark() #adds a dark background to the plot 
p1+theme_void() #removes everything but the points in the genome
p1+theme_excel() #make plots look like excel plots (LOL)

p1+theme(plot.background=element_rect(fill="black"), panel.background = element_rect(fill="black"))

#font and font size modifications
#apply global fonts
p1 + theme_classic(base_size = 25, base_family = "sans")
# apply specific fonts
p1 + labs(x="highway gas mileage (MPG)",y="City Gas Mileage (MPG)") +
theme_classic() + theme(axis.title.x=element_text(size = 15,angle=0,vjust = 0.5))

#other minor modifications that can be made
p2 <- ggplot(data=mpg) +
  aes(x=hwy, y= cty) +
  geom_point(size=4, #plot points with various modifications
             shape = 25,# there is a list of different shapes with a number ID (1-25)
             color="brown",
             fill="hotpink") +
  labs(title = "beautiful gas figures", # label various elements
       subtitle = "important research",
       x="highway gas milage", 
       y="city gas milage") +
  xlim(0,50) + #set extend of x-axis
  ylim(0,50) +
  theme_bw()

p2

colors() #any function that takes a color can use these colors 

################################################################################
#class variable mapped to color 
p1 <- ggplot(data=mpg) +
  aes(hwy, cty, color=class) +
  geom_point(size=3)
p1

p1 <- ggplot(data=mpg) +
  aes(hwy, cty, shape=class) +
  geom_point(size=3)
p1

#class mapped to size (not advised in many cases)
p1 <- ggplot(data=mpg) +
  aes(hwy, cty, size=class) +
  geom_point()
p1

#displacement (displ) of the engine mapped to point size
p1 <- ggplot(data=mpg) +
  aes(hwy, cty, size=displ) +
  geom_point()
p1

# displacement (displ) mapping to color -- heat map-like graph 
p1 <- ggplot(data=mpg) +
  aes(hwy, cty, color=displ) +
  geom_point(size=3)
p1

#mapping the same aesthetic to two different geoms
p2 <- ggplot(data=mpg) +
  aes(hwy, cty, color = drv) +
  geom_point(size=2) +
  geom_smooth(method="lm")
p2

?geom_smooth
#mapping regression line to all the points
p2 <- ggplot(data=mpg) +
  aes(hwy, cty) +
  geom_point(aes(color=drv), size=2) +
  geom_smooth(method="lm")
p2
#Different ways to map regression lines 
p2 <- ggplot(data=mpg) +
  aes(hwy, cty) +
  geom_point(size=2) +
  geom_smooth(aes(color=drv),method="lm")
p2

#################################################################################
#Using patchwork to generate multiple plots 
mpg
g1 <- ggplot(data=mpg) +
  aes(x=hwy,y=cty) + 
  geom_point(color="red") + 
  geom_smooth()
g1

g2 <- ggplot(data=mpg) +
  aes(x=fl,fill=I("maroon4"),color=I("black")) +
  geom_bar(stat="count") + 
  theme(legend.position="none")
g2

g3 <- ggplot(data=mpg) +
  aes(x=hwy,fill=I("slateblue"),color=I("black")) + 
  geom_histogram()
g3

g4 <- ggplot(data=mpg) +
  aes(x=fl,y=cty,fill=fl) + 
  geom_boxplot() + 
  theme(legend.position="none")

g4

#Combining plot with patchwork
#Place plot horizontally
g1 + g2

#vertical 
g1 + g2 + g3 + plot_layout(ncol=1)

#control the relative size of the plots
g1+g2+plot_layout(ncol=1,heights = c(1,4))

#add spacers 
g1 + plot_spacer() + g2 + plot_spacer() + g3 + plot_layout(ncol=5)

#Nesting of plots within other plots
g1+{
  g2+{
    g3+g4+plot_layout(ncol=1)
  }
} +plot_layout(ncol=1)


# / and | to specify layout as well
(g1 | g2 | g3)/g4

(g1 | g2) / (g3 | g4)


#annotating the plots 
(g1 | g2)/g4+plot_annotation("this is my title", caption="Figure 14")

# tag panels
(g1 | g2)/g4+plot_annotation(tag_levels = "I")

#faceting variables to generate multiple plots 
m1 <- ggplot(data=mpg)+
  aes(x=hwy,y=cty)+
  geom_point()
m1

m1 + facet_grid(class~fl) 

#change scale of the axes among facets 
m1 + facet_grid(class~fl, scales="free_y") #frees the axis of choice

m1 + facet_grid(class~fl, scales="free") #both X and Y

m1 + facet_grid(.~class, scales="free_y") #facet as columns

m1 + facet_grid(class~., scales="free") #facet as rows

m1 + facet_wrap(~class)

m1 + facet_wrap(~class + fl) 

m1 + facet_wrap(~class + fl, ncol=5) 

m1 + facet_wrap(~class, ncol=2, scale="free") 

?scale
?facet_wrap

