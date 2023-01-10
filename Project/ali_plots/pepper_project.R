
library(rentrez)
library(glue)
library(tidyverse)
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


novel_search <- entrez_search(db = "pubmed", 
                              term = "(novel plant viruses OR undescribed plant viruses) AND 1950:2020[PDAT]")

novel_search



## Plot novel plant virus reports

year <- 2000:2022
novel_virus_search <- glue("(novel plant viruses OR undescribed plant viruses) AND {year}[PDAT]")
all_plant_counts <- tibble(year = year,
                           novel_virus_search = novel_virus_search) %>% 
  mutate(novel_virus_search = map_dbl(novel_virus_search, ~entrez_search(db="pubmed",term = .x)$count))

novel_plot <- all_plant_counts %>% 
  select(year,novel_virus_search) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()

novel_plot

### Plotting NGS reports over the same time span

#Initial search of the pubmed database
ngs_i_search <- entrez_search(db = "pubmed", term = "(NGS plant virus OR next generation sequencing plant virus) AND 1950:2020[PDAT]")
ngs_i_search

year <- 2000:2022
ngs_search <- glue("(NGS plant virus OR next generation sequencing plant virus) AND {year}[PDAT]")
ngs_search_counts <- tibble(year = year,
                            ngs_search = ngs_search) %>% 
  mutate(ngs_search = map_dbl(ngs_search, ~entrez_search(db="pubmed",term = .x)$count))

ngs_plot <- ngs_search_counts %>% 
  select(year,ngs_search) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()

ngs_plot

#How to save a plot from ggplot2 (it will autosave the most recent plot)
ggsave("ngs_plot.png")


library(patchwork)
combined_plot <- novel_plot / ngs_plot / pmmov_plot

combined_plot

# Pepper mild mottle virus search plot
year <- 2000:2022
ngs_search <- glue("Pepper mild mottle virus AND {year}[PDAT]")
ngs_search_counts <- tibble(year = year,
                            ngs_search = ngs_search) %>% 
  mutate(ngs_search = map_dbl(ngs_search, ~entrez_search(db="pubmed",term = .x)$count))

pmmov_plot <- ngs_search_counts %>% 
  select(year,ngs_search) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()

pmmov_plot





install.packages("patchwork")
library(patchwork)
library(glue)
library(ggplot2)
library(tidyverse)
library(glue)

g2


g1 / g2

#Searching the nuccore / nucleotide database

year <- 1950:2020
year_2 <- 2000:2020 #could use this for another search 
pepper_search <- glue("(TYLCV OR tomato yellow leaf curl virus complete) AND {year}[PDAT]")
pepper_counts <- tibble(year = year,
                        pepper_search = pepper_search) %>% 
  mutate(pepper_search = map_dbl(pepper_search, ~entrez_search(db="nuccore",term = .x)$count))



g2<- pepper_counts %>% 
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

g2




