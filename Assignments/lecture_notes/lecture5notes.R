## Lesson 6: Tidying Data 

library(tidyverse)

## 3 rules for tidying data
# 1. Each variable must have its own column.
# 2. Each observation must have its own row.
# 3. Each value must have its own cell.

# Tidyr is a package in the tidyverse that helps to organize and tidy-up data. 

relig_income #part of R for practice
colnames(relig_income)

relig_income %>% pivot_longer(cols = c("<$10k", "$10-20k", "$20-30k", "$30-40k", "$40-50k", "$50-75k", "$75-100k", "$100-150k", ">150k", "Don't know/refused"), names_to = "income", values_to = "count")

relig_income %>% pivot_longer(cols = "<$10k":"Don't know/refused", names_to = "income", values_to = "count")

relig_income %>% pivot_longer(cols = !religion, names_to = "income", values_to = "count")

relig_income_tidy <- relig_income %>% pivot_longer(cols = !religion, names_to = "income", values_to = "count")

billboard
arrange(billboard, by = wk1)

billboard %>% pivot_longer(cols = starts_with("wk"), 
                           names_to = "week", 
                           values_to = "rank",
                           values_drop_na = TRUE)

#make week a numeric variable 

billboard %>% pivot_longer(cols = starts_with("wk"), 
                           names_to = "week", 
                           names_prefix = "wk", # drop the given prefix
                           names_transform = list(week = as.integer),
                           values_to = "rank",
                           values_drop_na = TRUE) %>%
  arrange(rank, desc(week))

# multiple variables in column names
who #world health organization data
glimpse(who)

who %>% pivot_longer(cols = new_sp_m014:newrel_f65, 
                     names_to = c("diagnosis", "gender", "age"),
                     names_pattern = "new_?(.*)_(.)(.*)",
                    values_to = "count") %>%
  glimpse()

#? indicates that the element
# before it "_" may or may not be there

# columns are multiple observations 

# make the family data set
family <- tribble(
  ~family,  ~dob_child1,  ~dob_child2, ~gender_child1, ~gender_child2,
  1L, "1998-11-26", "2000-01-29",             1L,             2L,
  2L, "1996-06-22",           NA,             2L,             NA,
  3L, "2002-07-11", "2004-04-05",             2L,             2L,
  4L, "2004-10-10", "2009-08-27",             1L,             1L,
  5L, "2000-12-05", "2005-02-28",             2L,             1L,
)
family <- family %>% mutate_at(vars(starts_with("dob")), parse_date)

glimpse(family)

family %>% pivot_longer(cols = !family, 
               names_to = c(".value","child"),
               names_sep = "_", 
               values_drop_na = TRUE)

#pivot_wider

table2

table2 %>% pivot_wider(names_from = type, values_from = count)

# separating variable

table3

table3 %>% separate(rate, into =c("class", "population"), sep = "/")

# split by number of characters

table3 %>% separate(rate, into =c("class", "population"), sep = 5) #sep will split things into 2

# mix of data and notes in a cell

field_notes<-tibble(
  ID = c(023, 456, 167, 897), 
  sex = c("F","F","M","F"),
  mass = c("15.6 first sample of the day","16.0","17.2 caught with female 456","14.9 last sample of the day"))

field_notes

field_notes %>% separate(mass, into = c("mass", "notes"), sep = " ")

field_notes %>% separate(mass, into = c("mass", "notes"), 
                         sep = " ", extra = "merge")

field_notes_sep <- field_notes %>% separate(mass, into = c("mass", "notes"), 
                         sep = " ", extra = "merge", 
                         convert=TRUE)
field_notes_sep

#uniting columns 

field_notes_sep %>% 
  unite (col ="ID_sex", ID, sex)

field_notes_sep %>% 
  unite (col ="ID_sex", ID, sex, sep = "")

field_notes_sep %>% 
  unite (col ="ID_sex", ID, sex, sep = "$")

field_notes_sep %>% 
  unite (col ="ID_sex", ID, sex, sep = "$", remove = FALSE)

### Merging and joining data from different data sets

# inner_join(x,y) - joins matching observations in both x and y
# Outer joins
# left_join(x,y) - joins all observations in x and adds matching observations from y. By default will add NAs where observations from x have no match in y.
# right_join(x,y)- joins all observations in y and adds matching observations in x. By default will add NAs where observations from y have no match in x.
# full_join(x,y) - joins all observations from x and all observations from y. By default will add NAs where matching observations are missing in eaither x or y.

band_members
band_instruments

band_members %>% 
  inner_join(band_instruments, by = "name")

band_members %>% 
  full_join(band_instruments, by = "name")

band_instruments2

band_members %>% 
  full_join(band_instruments2, by = c("name" = "artist"),
            keep =TRUE)

#filter joins to select data in one data set based on another 
band_members %>%
  semi_join(band_instruments, by = "name")

band_members %>%
  anti_join(band_instruments, by = "name")

#Set operations (similar to filter joins)
# intersect(x, y) - return only observations in both x and y.
# union(x, y) - return unique observations in x and y.
# setdiff(x, y) - return observations in x, but not in y.



