require(tidyverse)

# laod Matt's ebird data from file folder (.csv files are easy to load)
MBT_ebird <- read_csv("Data/MBT_ebird.csv")

# laod from the website
MBT_ebird2.csv <- read_csv("https://github.com/mbtoomey/Biol_7263/blob/main/Data/MBT_ebird.csv?raw=true")

MBT_ebird_no_header <- read_csv("Data/MBT_ebird.csv", col_names = FALSE)

# Specify your own column names
MBT_ebird_no_header <- read.csv("Data/MBT_ebird.csv", col_names = c("first_column","second_column"))

glimpse(MBT_ebird.csv)

filter(ebird_cut2 )

head(MBT_ebird.csv)
