#looking for Populus occurence records in gbif
install.packages("spocc")
install.packages("scrubr")
library("spocc") #for getting gbif
library("scrubr") #for cleaning data
library(rgbif)
library(ggplot2)
library(mapr)
populus <- occ_search(scientificName = "Populus angustifolia James", limit = 900,hasCoordinate = TRUE, year ='1800,2018')
write.csv(populus$data, file="Populus_occurence.csv",row.names = FALSE)
map_ggplot(populus, map = "world", size = .2)
map_leaflet(populus) #interactive
populus_unclean<-read.csv("Populus_occurence.csv") #3/5 filters
populus2<-coord_incomplete(populus_unclean, lat = NULL, lon = NULL, drop = TRUE)
populus3<-coord_impossible(populus2, lat = NULL, lon = NULL, drop = TRUE)
populus4<-coord_unlikely(populus3, lat = NULL, lon = NULL, drop = TRUE)

