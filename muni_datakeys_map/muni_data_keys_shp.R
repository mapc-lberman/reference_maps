library(tidycensus)
library(tidyverse)
library(sf)
library(devtools)

# install.packages("devtools")
#devtools::install_github("MAPC/mapcdatakeys")

library(mapcdatakeys)

## 2010
# get 2010 Muni boundaries from Decennial Census
muni_geom <- mapcdatakeys::muni_sf(2010)
# cast to spatial data frame
sdf <- st_as_sf(muni_geom)
# check projection
st_crs(sdf)
# reproject to WGS 84
sdf_4326 <- st_transform(sdf, crs = 4326)
# check visually
plot(sdf_4326)

# 2020
# get 2020 Muni boundaries from Decennial Census
muni_geom_20 <- mapcdatakeys::muni_sf(2020)
# cast to spatial data frame
sdf20 <- st_as_sf(muni_geom_20)
# check projection
st_crs(sdf20)
# reproject to WGS 84
sdf20_4326 <- st_transform(sdf20, crs = 4326)
# check visually
plot(sdf20_4326)


#old school import from shp
# df = read_sf("C:/path_to_import/ma_muni_for_datakeys.shp") %>% 
#   select(!c(TOWN,SHAPE_AREA,SHAPE_LEN)) %>% 
#   rename(muni_id = TOWN_ID) %>% 
#   left_join(.,mapcdatakeys::all_muni_data_keys %>% select(muni_id, muni_name)) %>% 
#   mutate(across(.cols = c(muni_name, muni_id), .fns = as.character))

#export to shp
#sdf %>% write_sf("//path/to/export/ma_muni_shp_2010.shp")