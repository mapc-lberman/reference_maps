library(rgdal)
library(rgeos)
library(sf)

### joe basic crs transform in R

# set working directory on VM, sub-paths to inputs in next item
setwd("K:/DataServices//Datasets/Boundaries/Spatial")

# set input paths to vector files
mapc_twn_orig <- st_read("mapc_towns_poly.shp") 

#check crs and units (meters)
st_crs(mapc_twn_orig)

#transform to wgs84
mapc_twn_4326 <- st_transform(mapc_twn_orig, crs = 4326)

#check output
st_crs(mapc_twn_4326)

#export 
st_write(mapc_twn_4326, "mapc_towns_epsg_4326.shp")
