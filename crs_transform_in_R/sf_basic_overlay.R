# from Data_prep.R

options(scipen=999)


###
###
###

# SF version
library(sf)
library(dplyr)


# unzip polgyon files to a folder
# change the path to correct folder

data_path = "C:/Users/lberman/Downloads/"

# read shape files of source boundaries for towns, neighborhoods

sf_nbrhd_shp <- read_sf(paste0(data_path,"core_muni_nbhds/core_muni_nbhds_2023.shp"))
sf_twn_shp <- read_sf(paste0(data_path,"ma_municipalities/ma_municipalities.shp"))

# check crs
st_crs(sf_nbrhd_shp) # epsg 26986
st_crs(sf_twn_shp) # epsg 26986

# transform crs (mapc standard epsg 26986)  
# need to have layers match for geoprocessing
#sf_nbrhd_shp <- st_transform(sf_nbrhd_shp, crs = 26986)
#sf_twn_shp <- st_transform(sf_twn_shp, crs = 26986)


# ingest points
# sample download of 311 service calls from source:
# https://data.boston.gov/dataset/311-service-requests
raw_points <-
  read.csv("C:/Users/lberman/Downloads/log_311_calls_2024.csv")

# select type = "Rodent Activity" and drop rows lacking x,y, trim to minimal columns
points <- raw_points %>%
  filter(type %in% "Rodent Activity") %>% 
  filter(!is.na(longitude)) %>% 
  select(c(case_enquiry_id,case_status,type,location,neighborhood,latitude,longitude))

# create spatial object in sf
get_points <- st_as_sf(points, coords = c("longitude", "latitude"), crs = 4326)

#check crs
st_crs(get_points) # epsg 4326

# transform crs to match overlay data (mapc standard epsg 26986)
get_points <- st_transform(get_points, crs = 26986)


#overlay any of the boundaries with the listing records
pnt_towns.shape <- st_intersection(get_points, sf_twn_shp)
pnt_nei_1.shape <- st_intersection(get_points, sf_nbrhd_shp)


#count points in neighborhood polygons
# see doc: https://rstudio-pubs-static.s3.amazonaws.com/1113537_5c12778f1092412cbe4913b82618da98.html
points_join <- st_join(get_points, sf_nbrhd_shp, join = st_within)

# count the points within each neighborhood poly, with "nbhd_name" as group name
points_count <- count(as_tibble(points_join), nbhd_name) %>%
  arrange(desc(n)) %>% print()

# rejoin the points count column to the polygon object
count_result <- left_join(sf_nbrhd_shp, points_count, by = c("nbhd_name" = "nbhd_name"))

# note in the count_result join that the counts only match Boston, 
# while the other surrounding towns are NA




## sanity check with a map
library(ggplot2)

# trim to just boston
bos_rats <- count_result %>%
  filter(muni_name %in% "BOSTON")
  
input_year = "2024"
map_title = paste0(input_year," Neighborhood Rodent Activity")

# SET UP MAP FUNCTION USING GGPLOT
# update fill = n (where "n" is the name of the column with data to map)
# update data = bos_rats (name of spatial object with data to map)
# update the range buckets as in: round(max(bos_rats$n) with spatial obj and column
rat_plot <- ggplot() +
  geom_sf(data = bos_rats, linewidth = 0.001, aes(fill = n), color = "grey")+
  scale_fill_continuous(
    high = "purple", low = "white",
    breaks = c(
      round(max(bos_rats$n)*(1/5),0),
      round(max(bos_rats$n)*(2/5),0),
      round(max(bos_rats$n)*(3/5),0),
      round(max(bos_rats$n)*(4/5),0),
      max(bos_rats$n)),
    name = "units"
  )+
  geom_sf(data = bos_rats, fill = NA, color = "black", linewidth = 0.5)+
  labs(
    title = map_title,
    subtitle = "count of calls to 311 about rodents",
    caption = "Data: https://data.boston.gov/dataset/311-service-requests"
  ) +
  theme_minimal()+
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(fill = NA, color = "black", linewidth = 0.5)
  )

# create the plot (shows in plot panel)
rat_plot



## EXPORT THE DATA to file for input year
st_write(bos_rats, paste0(data_path, "bos_rat_counts_",input_year,".shp"))

