Arranging multiple plots with facet and patchwork
M. Toomey
2022-10-02
Multi-panel figures are a common feature of publications in many disciplines and a useful way to display complementary data plots. However, combining and arranging separate plots in a precisely align and repeatable way can be difficult with typical tools. The package patchwork works with ggplot and provides an intuitive way to combine plots.

Packages
library(ggplot2)
library(ggthemes)
library(patchwork)
###lotting multiple panel graphs with patchwork

g1 <- ggplot(data=mpg) +
  aes(x=hwy,y=cty) + 
  geom_point() + 
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


# place two plots horizontally
g1 + g2


# place 3 plots vertically
g1 + g2 + g3 + plot_layout(ncol=1)


# change relative area of each plot
g1 + g2 + plot_layout(ncol=1,heights=c(2,1))


g1 + g2 + plot_layout(ncol=2,widths=c(1,2))


# add a spacer plot (under construction)
g1 + plot_spacer() + g2


# use nested layouts
g1 + {
  g2 + {
    g3 +
      g4 +
      plot_layout(ncol=1)
  }
} +
  plot_layout(ncol=1)


# - operator for subtrack placement
g1 + g2 - g3 + plot_layout(ncol=1)


# / and | for intuitive layouts
(g1 | g2 | g3)/g4


(g1 | g2)/(g3 | g4)


# Add title, etc. to a patchwork
g1 + g2 + plot_annotation('This is a title', caption = 'made with patchwork')


# Change styling of patchwork elements
g1 + g2 +
  plot_annotation(
    title = 'This is a title',
    caption = 'made with patchwork',
    theme = theme(plot.title = element_text(size = 16))
  )


# Add tags to plots
g1 / (g2 | g3) +
  plot_annotation(tag_levels = 'a')


Swapping axis orientation for multipanel plot
g3a <- g3 + scale_x_reverse()
g3b <- g3 + scale_y_reverse() 
g3c <- g3 + scale_x_reverse() + scale_y_reverse()

(g3 | g3a)/(g3b | g3c)


(g3 + coord_flip() | g3a + coord_flip())/(g3b + coord_flip() | g3c + coord_flip())


Faceting variables to generate multiple plots
The faceting functions of ggplot allow you to separate and plot subsets of your data by variables within the data set.

# basic faceting with variables split by row, column, or both
m1 <- ggplot(data=mpg) + 
  aes(x=hwy,y=cty) + 
  geom_point() 

m1 +  facet_grid(class~fl)     


m1 + facet_grid(class~fl, scales="free_y")


m1 + facet_grid(class~fl, scales="free")


m1 + facet_grid(.~class)


m1 + facet_grid(class~.)


# use facet wrap when variables are not crossed
m1 + facet_grid(.~class)


m1 +  facet_wrap(~class)     


m1 + facet_wrap(~class + fl)


m1 + facet_wrap(~class + fl, drop=FALSE)


m1 + facet_grid(class~fl)