# packages
library(sf)
library(ggplot2)
library(dplyr)
library(tidygeocoder)

# update Food Retailers
# see K:/DataServices/Projects/Current_Projects/PublicHealth/Food_Systems/Online_map/data_axle_data_common_2021.csv


input_path <- "H:/0_PROJECTS/2025_food_retailers/shp/wgs84/"

# new data
food_2021 <- read_sf(paste0(input_path,"food_2021_wgs84.shp"))

st_crs(food_2021)

names(food_2021)

food_2021 <- food_2021 %>% 
  mutate(year = "2021")

names(food_2021)

# check store_types 2021
unique(food_2021$store_type)

food_2021 <- food_2021 %>% 
  select(c(coname,locnum,staddr,stcity,zip,naics,naics_6,store_type,year,geometry))


#food_2021_proj <- st_transform(food_2021, crs = 26986)

plot(food_2021)

class(food_2021)

# previous data [no crs]

#2016
food_2016 <- read_sf(paste0(input_path,"food_2016_wgs84.shp"))
st_crs(food_2016)

# csv not working, undefined projection.  needed to set crs in ArcPro
#from_csv_2016 <- read.csv(paste0(input_path,"food_2016.raw.csv"))
#use x, y for spatial df
# proj_csv_2016 <- st_as_sf(x = from_csv_2016,                         
#                           coords = c("longitude", "latitude"),
#                           crs = st_crs(26986))
# food_2016 <- proj_csv_2016
# names(food_2016)

food_2016 <- food_2016 %>% 
  mutate(year = "2016")

# check store_types
#unique(food_2016$prim_type)

food_2016 <- food_2016 %>% 
  mutate(
    coname = name,
    staddr = address,
    stcity = municipal,
    zip = zipcode,
    store_type = prim_type,
    locnum = "",
    naics = "",
    naics_6 = ""
  )

food_2016 <- food_2016 %>% 
  select(c(coname,locnum,staddr,stcity,zip,naics,naics_6,store_type,year,geometry))

st_crs(food_2016)

# food_2016_epsg4326 <- st_transform(food_2016, crs = 4326)
# st_crs(food_2016_epsg4326)

#names(food_2016_epsg4326)


plot(food_2016)


#2017
food_2017 <- read_sf(paste0(input_path,"food_2017_wgs84.shp"))
st_crs(food_2017)

# csv not working, undefined projection.  needed to set crs in ArcPro
# from_csv_2017 <- read.csv(paste0(input_path,"food_2017_wgs84.csv"))
# #use x, y for spatial df
# 
# proj_csv_2017 <- st_as_sf(x = from_csv_2017,                         
#                coords = c("longitude", "latitude"),
#                crs = st_crs(26986))


#food_2017 <- proj_csv_2017
names(food_2017)

food_2017 <- food_2017 %>% 
  mutate(year = "2017")

# check store_types
unique(food_2017$prim_type)

food_2017 <- food_2017 %>% 
  mutate(
    coname = name,
    staddr = address,
    stcity = municipal,
    zip = zipcode,
    store_type = prim_type,
    locnum = "",
    naics = "",
    naics_6 = ""
  )

food_2017 <- food_2017 %>% 
  select(c(coname,locnum,staddr,stcity,zip,naics,naics_6,store_type,year,geometry))

st_crs(food_2017)

# food_2017_epsg4326 <- st_transform(food_2017, crs = 4326)
# st_crs(food_2017_epsg4326)


plot(food_2017)



#bind

food_retail <- rbind(food_2021,food_2016,food_2017)

# names error
# ck names: names(food_2021)==names(food_2017_epsg4326)


# geocode addresses into new fields for consistent x,y

## CONCAT CLEAN ADDRESSES
clean_addr <- food_retail %>% 
#  mutate(fix_zip = as.character(str_pad(Zip, width = 5, side = c("left"), pad = 0))) %>% 
  mutate(concat_addr = as.character(paste0(staddr,", ",stcity,", MA,",zip)))

# Filtering by one year 2021
addr_2021 <- clean_addr %>% 
  filter(year %in% "2021")

#geocode addresses
esri_pass_2021 <- addr_2021 %>% 
  geocode(address = 'concat_addr', method = 'arcgis') 

# drop the orig geometry
esri_gc_2021 <- esri_pass_2021 %>% 
  select(-c(geometry))
class(esri_gc_2021)

#fix goshen address
esri_gc_2021[esri_gc_2021$locnum=='106221351', "staddr"] <- "31 Main St"

# Filtering by one year 2017
addr_2017 <- clean_addr %>% 
  filter(year %in% "2017")

#geocode addresses
esri_pass_2017 <- addr_2017 %>% 
  geocode(address = 'concat_addr', method = 'arcgis') 

# drop the orig geometry
esri_gc_2017 <- esri_pass_2017 %>% 
  select(-c(geometry))
class(esri_gc_2017)


#fix goshen address
esri_gc_2021[esri_gc_2021$locnum=='106221351', "staddr"] <- "31 Main St"
esri_gc_2021[esri_gc_2021$locnum=='106221351', "concat_addr"] <- "31 Main St, Goshen, MA,01032"
esri_gc_2021[esri_gc_2021$locnum=='106221351', "lat"] <- 42.43997
esri_gc_2021[esri_gc_2021$locnum=='106221351', "long"] <- -72.79990



# Filtering by one year 2016
addr_2016 <- clean_addr %>% 
  filter(year %in% "2016")

#geocode addresses
esri_pass_2016 <- addr_2016 %>% 
  geocode(address = 'concat_addr', method = 'arcgis') 

# drop the orig geometry
esri_gc_2016 <- esri_pass_2016 %>% 
  select(-c(geometry))
class(esri_gc_2016)

# rbind the versions with new geocoded x, y
food_retail_geocode <- rbind(esri_gc_2021,esri_gc_2017,esri_gc_2016)

# remove odd entry with false geocoded result
food_retail_geocode <- food_retail_geocode %>% filter(coname != "Shrimp Belly")

# cast x,y to spatial df
food_retail_sf <- food_retail_geocode %>% 
  st_as_sf(coords = c("long", "lat"), crs=4326)

class(food_retail_sf)

food_retail_sf <- food_retail_sf %>% 
  mutate(conc_addr = concat_addr) %>% 
  select(-c(concat_addr))
  select(c(coname,locnum,staddr,stcity,zip,naics,naics_6,store_type,year,conc_addr,geometry))


plot(food_retail_sf)

st_write(food_retail_sf, "H:/0_PROJECTS/2025_food_retailers/shp/food_retail_multiyear.shp")
