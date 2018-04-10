#looking for Populus occurence records in gbif
install.packages("spocc")
install.packages("scrubr")
library("spocc") #for getting gbif
library("scrubr") #for cleaning data
library(rgbif)
library(ggplot2)
library(mapr)
populus <- occ_search(scientificName = "Populus angustifolia James", limit = 900,hasCoordinate = TRUE, year ='1880,2018') #138 years/ 3= 46 years
write.csv(populus$data, file="Populus_occurence.csv",row.names = FALSE)
map_ggplot(populus, map = "world", size = .2)
populus_unclean<-read.csv("Populus_occurence.csv") #3/5 filters
populus2<-coord_incomplete(populus_unclean, lat = NULL, lon = NULL, drop = TRUE)
populus3<-coord_impossible(populus2, lat = NULL, lon = NULL, drop = TRUE)
populus4<-coord_unlikely(populus3, lat = NULL, lon = NULL, drop = TRUE)
years<-populus4$year
map_ggplot(populus4, map = "world", size = .2)

df <- data.frame(populus4)
populus1880_1926<--subset(df, year>1879 & year<1927)
map_ggplot(populus1880_1926, map = "world", size = .2)
populus1927_1972<-subset(df, year>1926 & year<1973)
populus1973_2018<-subset(df, year>1972 & year<2018)
       