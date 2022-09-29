require(tidyverse)
mtcars #data frame

as_tibble(mtcars) #transforming to a tibble removes row names

as_tibble(mtcars, rownames = "make_model") # retain row name and make a new variable

# Selecting columns (variables)

data("starwars") # load starwars dataset
head(starwars)
tail(starwars)
glimpse(starwars)
starwars_cut1 <- select(starwars, name:species) #specified the name of the variables
starwars_cut1 <- select(starwars, 1:11) # select by column number
starwars_cut1 <- select(starwars, !c(films, vehicles, starships)) # select by excluding columns we do not have
starwars_cut1 <- select(starwars, !where(is.list)) #select by excluding columns that are NOT lists
glimpse(starwars_cut1)

# Select also has a variety of helper functions
# Select name column and any column that contains the word color 
starwars_color2 <- select(starwars, name, contains("color"))

# Arrange to recorder rows of the dataset
# Arrange shortest first
arrange(starwars_cut1, by = height)
# Arrange tallest first
arrange(starwars_cut1, by = desc(height))
# Cells with no values get put at the tail
tail(arrange(starwars_cut1, by = desc(height)))

# Filter to select observations by their values
filter(starwars_cut1, mass == 77) # == exactly equal
filter(starwars_cut1, mass <= 77) # <= less than or equal to
filter(starwars_cut1, mass != 77) # != where mass is NOT equal to 77
filter(starwars_cut1, mass != 77 | is.na(mass)) # != where mass is NOT equal to 77 or missing (NA)
filter(starwars_cut1, eye_color == "black" | eye_color == "blue") # "|" specifies "or"
filter(starwars_cut1, eye_color == "black" | eye_color == "blue") # "&" specifies "and"
filter(starwars_cut1, eye_color %in% c("black","green","blue")) 

# slice is another useful tool 

slice_head(starwars_cut1, n=5) # top 5 extraction
slice_sample(starwars_cut1, n=5) #random extraction
slice_max(starwars_cut1, mass) # maximum value extracted
slice_min(starwars_cut1, mass) # minumum value extracted

# mutate creates new variable from existing. It will overwrite prexisting variables if they are named the same. 
starwars_cut1 <- mutate(starwars_cut1, resid_mass = mass/height)
starwars_resid <- transmute(starwars_cut1, name = name, resid_mass = mass/height) # Data set with the column name and a new column

starwars_heft <- transmute(starwars_cut1, name = name, heft = min_rank(mass))
arrange(starwars_heft, heft)
arrange(starwars_heft, by = desc(heft))

# Summarize - collapse values into summary stats
summarize(starwars_cut1, mean_mass = mean(mass), SD_mass =sd(mass)) #not exciting
summarize(starwars_cut1, mean_mass = mean(mass, na.rm =TRUE), SD_mass =sd(mass, na.rm =TRUE)) # summarize all observations of varible in the column


# Grouping data VERY COOL and USEFUL
starwars_cut1 <- group_by(starwars_cut1, species)
glimpse(starwars_cut1)
summarize(starwars_cut1, mean_mass = mean(mass, na.rm =TRUE), SD_mass =sd(mass, na.rm =TRUE)) # summarize all observations of varible in the column
ungroup(starwars_cut1)

# Piping to combine actions
starwars_cut1 %>%
filter (mass > 0) %>%
group_by (species) %>%
summarize (mean_mass = mean (mass), SD_mass = sd(mass))
# lets remove species observed only once
starwars_cut1 %>%
  filter (mass > 0) %>%
  group_by (species) %>%
  mutate(count = n()) %>%
  filter(count > 1) %>%
  summarize (mean_mass = mean (mass), SD_mass = sd(mass), count = max(count))

sw_counts <- starwars_cut1 %>%
  filter (mass > 0) %>%
  group_by (species) %>%
  transmute(name = name, species = species, count = n()) %>%




  
  
