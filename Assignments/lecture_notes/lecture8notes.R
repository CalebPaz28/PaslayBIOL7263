snippet ## ---------------------------
##
## Script name: Lecture 8 : GIS in R - Raster and Points 
##
## Purpose of script: Lecture notes and Ideas
##
## Author: Caleb Paslay
##
## Date Created: 2022-10-20
##
##
## ---------------------------
##
## Notes: 1. learn how to import, plot, and modify
##   Raster file: pixelated or gridded data where each cell is a value
##  Shapefiles: Vectors of features, points, lines, polygons
## ---------------------------

## load the packages needed:  

library(tidyverse)
detach(package:tidyverse, unload =TRUE)
detach(package:ggplot2, unload = TRUE)
detach(package:tidyr, unload = TRUE)
library(ggplot2)

install.packages(c("sp","rgdal","raster","rgeos","geosphere","dismo"))
library(sp) # classes for vector data (polygons, points, lines)
library(rgdal) # basic operations for spatial data
library(raster) # handles rasters
library(rgeos) # methods for vector files
library(geosphere) # more methods for vector files
library(dismo) # species distribution modeling tools

https://worldclim.org/data/bioclim.html 

#Load a raster file 
bio1 <- raster("GIS_lessons/WORLDCLIMATE_Rasters/wc2.1_10m_bio_1.tif")
plot(bio1) #plot the raster

bio1_f <- bio1*9/5+32
plot(bio1_f) #converted this to Fherenhit

bio1

#create stacks of raster files 
clim_stack <- stack(list.files("GIS_lessons/WORLDCLIMATE_Rasters/", full.names = TRUE,
                               pattern = ".tif"))

list.files("GIS_lessons/WORLDCLIMATE_Rasters/", full.names = TRUE,
                               pattern = ".tif")

plot(clim_stack, nc = 5)

clim_stack


my_clim_stack <- stack(raster("GIS_lessons/WORLDCLIMATE_Rasters/wc2.1_10m_bio_1.tif"),
                       raster("GIS_lessons/WORLDCLIMATE_Rasters/wc2.1_10m_bio_2.tif"),
                       raster("GIS_lessons/WORLDCLIMATE_Rasters/wc2.1_10m_bio_3.tif"))

plot(my_clim_stack)

names(my_clim_stack) <-c("annual_mean_temp","mean_diurnal_range","isothermality")
plot(my_clim_stack)

# Plot bivariate relationships among climate variables
pairs(my_clim_stack) 

#Load some country shape files 
http://www.naturalearthdata.com/downloads/10m-cultural-vectors/ 

countries <- shapefile("GIS_lessons/Country_Shapefiles/ne_10m_admin_0_countries.shp")
countries
plot(countries, col = "goldenrod", border = "darkblue")

USA <- shapefile("GIS_lessons/USA/") #dont use this, I was just messing
USA
plot(USA, col = "green", border = "black")

#Plot climate raster and country borders 
plot(my_clim_stack[[3]])
plot(countries, add=TRUE) #add function adds to the existing plot

dev.new() #puts graphics in a new window

# pick points to model our climate niche, this will take time to load. 

my_sites <- as.data.frame(click(n=10))
my_sites


write.csv(my_sites,"GIS_lessons/coordinates.csv") # how to write CSV


names(my_sites) <- c("longitude", "latitude") #changing variable names
my_sites

#Extract climate variable values ar your points

env <- as.data.frame(extract(my_clim_stack, my_sites))
env

extract(my_clim_stack, my_sites)

my_sites <- cbind(my_sites, env)
my_sites

#create a shape file of my sites

#get the projection from the raster file 
my_Crs <- projection(my_clim_stack)
my_Crs

#Apply that projection to our points to create a shapefile

my_sites_shape <- SpatialPointsDataFrame(coords = my_sites, data = my_sites, 
                                         proj4string = CRS(my_Crs))

plot(my_clim_stack[[2]])
points(my_sites_shape, pch = 16)
plot(countries, add = TRUE)

#Generate set of random points for comparison to our selected locations 
bg <- as.data.frame(randomPoints(my_clim_stack, n=1000))

names(bg) <- c("longitude", "latitude")
head(bg)

plot(my_clim_stack[[2]])
points(bg, pch = ".")

bgEnv <- as.data.frame(extract(my_clim_stack, bg))
head(bgEnv)

bg <- cbind(bg, bgEnv)
head(bg)


#train the model (fit the model)

pres_bg <- c(rep(1, nrow(my_sites)), rep(0, nrow(bg)))
pres_bg

train_data <- data.frame(pres_bg = pres_bg,
                         rbind(my_sites, bg))

head(train_data)

# The model 
my_model <- glm(
  pres_bg ~ annual_mean_temp*mean_diurnal_range*isothermality
  + I(annual_mean_temp^2) + I(mean_diurnal_range^2) + I
  (isothermality^2),
  data = train_data, 
  family = "binomial",
  weights = c(rep(1, nrow(my_sites)), rep(nrow(my_sites)/nrow(bg), 
                                          nrow(bg)))
)

  
summary(my_model)
  
  # use this model to predict climate niche
  
  
my_world <- predict(
    my_clim_stack,
    my_model,
    type = "response")
  
my_world

#plot my world 
plot(my_world)
plot(countries, add = TRUE)
points(my_sites_shape,col = "darkred",pch = 16)

?points

#save your world 
writeRaster(my_world, "GIS_lessons/My_Climate_Space/my_world", format = "GTiff",
            overwrite = TRUE, progress = "text")

#Threshold preferred regions

my_world_thresh <- my_world >= quantile(my_world, 0.75)
plot(my_world_threshold)



# compare my climate space to the world 

# convert all values not equal to 1 to NA
my_world_thresh <- calc(my_world_thresh, fun=function(x) ifelse(x==0 | is.na(x), NA, 1))


my_best_sites <- randomPoints(my_world_threshold, 1000)
my_best_env <- as.data.frame(extract(my_clim_stack, my_best_sites))

# plot values of climate variables for my world vs whole globe 

smoothScatter(x = bgEnv$annual_mean_temp, y = bgEnv$isothermality, col = "lightblue")
points(x = my_best_env$annual_mean_temp, y = my_best_env$isothermality, col = "red",
       pch = 16, cex=0.2)
points(x = my_sites$annual_mean_temp, y = my_sites$isothermality, col = "black", 
       pch = 16)
legend(
  "bottomright", inset=0.01,
  legend = c("world","my niche", "my locations"),
  pch = 16,
  col = c("lightblue", "red", "black"),
  pt.cex = c(1,0.4, 1)
)

  
annual_mean_temp*mean_diurnal_range*isothermality

  




