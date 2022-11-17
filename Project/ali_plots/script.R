# For Dr. Ali 

library(rentrez) # now we can load rentrez
library(tidyverse) 
library(ggplot2)
library(glue)


p_microphomina_search <- entrez_search(db = "pubmed", term = "macrophomina phaseolina[ORGN]
                                       AND 1950:2022[PDAT]", retmax = 500)
p_microphomina_search


p_micro_sums <- entrez_summary(db = "pubmed", id = p_microphomina_search$ids)


# m. phaseolina only
year <- 1950:2020
p_macro_search <- glue("macrophomina phaseolina[ORGN] AND {year}[PDAT]")
search_counts <- tibble(year = year,
                        p_macro_search = p_macro_search) %>% 
  mutate(p_macro_search = map_dbl(p_macro_search, ~entrez_search(db="pubmed",term = .x)$count))
         
search_counts %>% 
  select(year,p_macro_search) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()

#cotton only


quick_search <- entrez_search(db = "pubmed", term = "cotton viruses AND 1950:2020[PDAT]")
quick_search


year <- 1950:2020
cotton_papers <- glue("cotton viruses AND {year}[PDAT]")
search_counts_1 <- tibble(year = year,
                          cotton_papers = cotton_papers) %>% 
  mutate(cotton_papers = map_dbl(cotton_papers, ~entrez_search(db="pubmed",term = .x)$count))


search_counts_1 %>% 
  select(year, cotton_papers) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size = 1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()


## Cotton and m. phaseolina
year <- 1950:2020
p_macro_search <- glue("macrophomina phaseolina[ORGN] AND {year}[PDAT]")
cotton_papers <- glue("cotton viruses AND {year}[PDAT]")

search_counts_2 <- tibble(year = year,
                          p_macro_search = p_macro_search,
                          cotton_papers = cotton_papers) %>% 
  mutate(p_macro_search = map_dbl(p_macro_search, ~entrez_search(db="pubmed",term = .x)$count),
         cotton_papers = map_dbl(cotton_papers, ~entrez_search(db = "pubmed", term = .x)$count))



search_counts_2 %>% 
  select(year, p_macro_search, cotton_papers) %>% 
  pivot_longer(-year) %>% 
  ggplot(aes(x = year,
             y = value,
             group = name,
             color = name))+
  geom_line(size =1)+
  geom_smooth(size =1)+
  geom_point(color = "black")+
  theme_bw()




