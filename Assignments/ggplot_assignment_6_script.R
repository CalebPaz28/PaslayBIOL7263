library()
library(ggplot2)
library(patchwork)
library(ggthemes)


MBT_ebird <- read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true")

1. First calculate the total number of species seen each month of each year 
in each location. Then plot the number of species seen each month 
with the color of the points indicating year and facet this plot by location. 

View(MBT_ebird)

colnames(MBT_ebird)

count_bird <- MBT_ebird %>% 
  select(common_name, month, year, location, count) %>% 
  group_by(location, common_name, month, year, count) %>% 
  summarise(location) %>% 
View()

plot_1 <- ggplot(data = count_bird) +
  aes(month, count) +
  geom_point(aes(color = year), size = 1)+
  facet_wrap(~location) +
  xlab("month") +
  ylab("number of species")+
  ggtitle("Birds")
plot_1


2. 

assignment5_1 <- read_csv("Assignments/Data/part1_pivot.csv")
assignment5_2 <- read_csv("Assignments/Data/part_2_pivot.csv")
assignment5_3 <- read_csv("Assignments/Data/tidy_data.csv")
assignment5_mean_sd <- read_csv("Assignments/Data/mean_&_SD.csv")

Plot a comparison of mass by treatment including the individual observations, 
the mean, and standard error of the mean. Use point color or shape to indicate the sex.

plot_2 <- ggplot(assignment5_3, 
                 aes(x = test, mass))+
  geom_jitter(aes(col = sex), size =2, na.rm = TRUE)+
  stat_summary(fun = mean, geom = "crossbar", width = 0.5, color = "green") +
  stat_summary(geom = "errorbar", width = 0.3) +
  labs(x ="Test Group", y = "Mass")+
  theme_bw()

plot_2
#another way
plot_2.1 <- ggplot(assignment5_3, 
                       aes(x = test, y = mass, fill = sex)) +
  geom_boxplot()+
  theme_bw()

plot_2.1

plot_2.2 <- ggplot(assignment5_3, 
                   aes(x = age, y = mass, color= test,na.omit =TRUE))+
  geom_point(size = 2)+
  geom_smooth(method = "lm", se = FALSE)+
  labs(x="Age", y="Mass")+
  theme_bw()
plot_2.2
  
plot2.2 <- ggplot(assignment5_3, 
                  aes(x = age, y = mass, color= test,na.omit =TRUE))+
  geom_point(size = 2)+
  geom_smooth(method = "lm", se = FALSE)+
  theme_bw()+
  labs(x="Age", y="Mass") + 
  theme(text=element_text(size=12, face="bold"),
    legend.position = c(0.15,0.85), 
legend.box.background = element_rect(color="black"))

plot2.2

combined_plot <- plot_2 / plot_2.2

combined_plot2 <- combined_plot + plot_annotation("Distribution of Data", 
                                tag_levels = "A", caption = "Figure 1")
  






