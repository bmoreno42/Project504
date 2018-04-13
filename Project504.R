#looking for Populus occurence records in gbif
setwd("~/OneDrive - University of Tennessee/EEB 504 Phylogenetic Methods/Project504")
readRenviron(".Renviron")
any(grepl("^\\.Renviron", list.files("~", all.files = TRUE)))
options("noaakey" = Sys.getenv("noaakey"))

library(countyweather)
library(sp)
library(maps)
library(maptools)
library(spocc) #for getting gbif
library(scrubr) #for cleaning data
library(rgbif)

populus <- occ_search(scientificName = "Populus angustifolia James", limit = 900,hasCoordinate = TRUE, year ='1880,2018') #138 years/ 3= 46 years
write.csv(populus$data, file="Populus_occurence.csv",row.names = FALSE)
populus_unclean<-read.csv("Populus_occurence.csv") #3/5 filters
populus2<-coord_incomplete(populus_unclean, lat = NULL, lon = NULL, drop = TRUE)
populus3<-coord_impossible(populus2, lat = NULL, lon = NULL, drop = TRUE)
populus4<-coord_unlikely(populus3, lat = NULL, lon = NULL, drop = TRUE)

latlong2state <- function(pointsDF) {
  # Prepare SpatialPolygons object with one SpatialPolygon
  # per state (plus DC, minus HI & AK)
  county <- map('county', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(county$names, ":"), function(x) x[1])
  county_sp <- map2SpatialPolygons(county, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Convert pointsDF to a SpatialPoints object 
  pointsSP <- SpatialPoints(pointsDF, 
                            proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Use 'over' to get _indices_ of the Polygons object containing each point 
  indices <- over(pointsSP, county_sp)
  
  # Return the state names of the Polygons object containing each point
 countyNames <- sapply(county_sp@polygons, function(x) x@ID)
  countyNames[indices]
}

# Test the function 
populus4county <- data.frame(x = populus4$longitude, y = populus4$latitude)
counties<-latlong2state(populus4county)
datacounties<-data.frame(counties)
fips<-county.fips
datafips<-data.frame(fips)
colnames(datafips)[which(names(datafips) == "polyname")] <- "counties"
datafips
mergeddata<-merge(datafips,datacounties,by="counties",all=F)
library(ggplot2)
library(mapr)

years<-populus4$year
map_ggplot(populus4, map = "world", size = .2)

df <- data.frame(populus4)
populus1880_1926<--subset(df, year>1879 & year<1927)
map_ggplot(populus1880_1926, map = "world", size = .2)
populus1927_1972<-subset(df, year>1926 & yrear<1973)
populus1973_2018<-subset(df, year>1972 & year<2018)
       

#climate data
#adding zeros to make 5 digit
u1 <- mergeddata$fips
newdat<-formatC(u1, width = 5, format = "d", flag = "0")
newmergeddata<-cbind(mergeddata,newdat)
u2<-newmergeddata$newdat
factored<-as.character(levels(u2))

write_daily_timeseries(fips = factored, date_min = "1880-01-01", 
                       date_max = "2018-01-01", var = "tmax", 
                       out_directory = "~/OneDrive - University of Tennessee/EEB 504 Phylogenetic Methods/Project504")


