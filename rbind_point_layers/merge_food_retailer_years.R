# packages
library(sf)
library(ggplot2)
library(dplyr)

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



#not yet used below

#plot(ma_poly_buf_neg)

st_write(food_retail, "H:/0_PROJECTS/2025_food_retailers/shp/food_retail_multiyear.shp")
