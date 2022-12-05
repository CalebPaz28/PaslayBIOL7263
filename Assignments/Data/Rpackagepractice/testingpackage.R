library("tidyverse") #to allow us to use the 'read_csv' function

dataset1 <-read_csv("data_example.csv")
dataset2 <-read_csv("data_example_2.csv")

glimpse(dataset1)
glimpse(dataset2)

library("devtools") # for 'install' and 'load_all' functions

# set working directory back to RPackagePractice
# because you can't install a package from inside of itself
# which I found out the hard way

install("rateLawOrders")
search() #to see that our package is installed
load_all("rateLawOrders") #to laod the package

# let's check that our documentation for each function worked
?all_orders
?plot_orders

dataset1_orders <- all_orders(dataset1)
plot_orders(dataset1_orders)

dataset2_orders <- all_orders(dataset2)
plot_orders(dataset2_orders)

