#library(rgdal)
#library(rgeos)
library(sf)
library(dplyr)
library(ggplot2)
library(readr)


# UMN transit access shp join 2021 dataset
# lberman 2024-02-22

# enter data year
yr = "2021"

# enter number of minutes for dataset (5 min intervals up to 45min)
min = 45
sec <- 60*(min)


# enter working directory
path = "K:/DataServices/Datasets/Transportation/UMN_accessibility_observatory/"

# input vector file: 2020 census tracts w density
ct_poly <- st_read("K:/DataServices/Datasets/Boundaries/Spatial/CENSUS2020_TRCT_SHP/tracts_w_density/2020_mapc_tracts_density_20230301.shp") 
#check crs and units: mapc default epsg: 26986 (meters)
st_crs(ct_poly)

# input vector file: MAPC boundary for selection
mapc_poly <- st_read("K:/DataServices/Datasets/Boundaries/Spatial/mapc_outline_epsg_4326.shp") 

#check crs and units: mapc default epsg: 26986 (meters)
st_crs(mapc_poly)
mapc <- st_transform(mapc_poly, crs = 26986)
st_crs(mapc)


# input UMN transit access tabular data for tracts
umn_tracts = read_csv(paste0(path, yr, "/raw_data/Massachusetts_25_transit_census_tract_2021.csv"))  %>%
  mutate(umn_geoid = as.character(geoid)) %>% 
  select(-c(parent_area,geoid))

umn_tracts <- umn_tracts %>% 
  rename("summ_lvl" = "summary_level",
         "wgtd_avg" = "weighted_average")


# join tabular UMN table to poly
join <- left_join(ct_poly, umn_tracts, by = c("GEOID" = "umn_geoid"))

# filter by threshold (commuting time) value  [units = seconds] eg 3600 = 45 min
subset <- filter(join, threshold == sec)

# ck mapped objects
test_map <- subset %>% 
  ggplot(aes(fill = wgtd_avg)) + # create a ggplot object and 
  geom_sf() + # plot all local authority geometries
  scale_fill_viridis_c(option = "magma",begin = 0.1)
test_map  

## export to shp
st_write(subset, paste0(path, yr, "/merged_shp/2021_MA_CT_", min, "min.shp"))


## trim down to mapc region only

mapc_trim <- st_join(subset, mapc, left = FALSE, largest = TRUE)
st_crs(mapc_trim)

# ck map of selection objects
mapc_map <- st_transform(mapc_trim, crs = 4326)
st_crs(mapc_map)

mapc_map2 <- mapc_map %>% 
  ggplot(aes(fill = wgtd_avg)) + # create a ggplot object and 
  geom_sf() + # plot all local authority geometries
  coord_sf(xlim = c(-71.3, -70.9), ylim = c(42.2,42.5), expand = FALSE) +
  scale_fill_viridis_c(option = "magma",begin = 0.1)
mapc_map2

## export to shp
st_write(mapc_trim, paste0(path, yr, "/merged_shp/2021_MAPC_CT_", min, "min.shp"))
