library(rgdal)
library(rgeos)
library(sf)

### joe basic crs transform in R

# set working directory on VM, sub-paths to inputs in next item
setwd("K:/DataServices//Datasets/Boundaries/Spatial")

# set input paths to vector files
mapc_twn_orig <- st_read("mapc_towns_poly.shp") 

mapc_border_orig <- st_read("mapc_outline_poly.shp") 



#check crs and units (meters)
st_crs(mapc_twn_orig)

st_crs(mapc_border_orig)

#transform to wgs84
mapc_twn_4326 <- st_transform(mapc_twn_orig, crs = 4326)

mapc_border_4326 <- st_transform(mapc_border_orig, crs = 4326)


#check output
st_crs(mapc_twn_4326)

st_crs(mapc_border_4326)


#export 
st_write(mapc_twn_4326, "mapc_towns_epsg_4326.shp")

st_write(mapc_border_4326, "mapc_outline_epsg_4326.shp")

#export to geojson
#st_write(mapc_twn_4326, "mapc_towns_epsg_4326.geojson") 
