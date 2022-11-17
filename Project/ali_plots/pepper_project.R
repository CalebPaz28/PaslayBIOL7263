
library(rentrez)
# Pepper virus search 
pepper_virus_search <- entrez_search(db = "pubmed", term = "(pepper viruses OR capsicum viruses) AND 1950:2022[PDAT]")
pepper_virus_search


year <- 1950:2020
pepper_search <- glue("(pepper viruses OR capsicum viruses) AND {year}[PDAT]")
pepper_counts <- tibble(year = year,
                        pepper_search = pepper_search) %>% 
  mutate(pepper_search = map_dbl(pepper_search, ~entrez_search(db="pubmed",term = .x)$count))

g1 <- pepper_counts %>% 
  select(year,pepper_search) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()

g1

# All plant virus search 
plant_virus_search <- entrez_search(db = "pubmed", term = "plant virus AND 1950:2020[PDAT]")
plant_virus_search


year <- 1950:2020
plant_search <- glue("plant viruses AND {year}[PDAT]")
all_plant_counts <- tibble(year = year,
                           plant_search = plant_search) %>% 
  mutate(plant_search = map_dbl(plant_search, ~entrez_search(db="pubmed",term = .x)$count))


entrez_db_searchable("pubmed")

g2<- all_plant_counts %>% 
  select(year,plant_search) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()

install.packages("patchwork")
library(patchwork)

g2


g1 / g2

