
cars


ggplot(cars, aes(speed, dist)) +
  geom_col(fill = "purple", color = "purple") +
  geom_line(color = "darkblue") +
  geom_point(size = 1.5, color = "black") +
  stat_summary(fun.data = "mean_cl_boot") +
  theme_bw()


?stat_summary
?group
  
?lm  
  
?geom_line

class(cars$speed)
class(cars$dist)
