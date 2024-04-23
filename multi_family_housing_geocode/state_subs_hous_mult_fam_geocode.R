library(dplyr)
library(stringi)
library(tidygeocoder)
library(sf)
library(readr)
library(ggplot2)
library(tidyr)

#author: lberman
#updated 2024-04-18

# to geocode points for multi family building addresses 
# airtable: https://airtable.com/appOJcXh3ZWTq3UY7/tbl8Z3tNwv6peE0Yr/viwQJXHkKTQKLmtUt?blocks=bipHxsN8jyjmIQCje
# tab:  State Subsidized Public Housing - DEV
# view:  All Fields


### REQUIRED: path to files
input_path = "H:/0_PROJECTS/2024_mult_fam_bldg_geocode/input/"
exp_path = "H:/0_PROJECTS/2024_mult_fam_bldg_geocode/output/"

### REQUIRED:  RAW DATA FILENAME
# downloaded from above airtable view with date suffix in filename
# CHANGE Field name from City/Town to City BEFORE READING csv, change Record ID to Record_ID

raw_data = "State_Subs_Public_Housing_DEV_All_Fields_TRIM_2024-04-18.csv"

### 
# PROCESSING
###

### load data
assets <- read_csv(paste0(input_path,raw_data)) %>% 
  mutate(state = "MA ") %>% 
  mutate(fix_addr = Address)


#### pre process cleaning 

assets1 <- assets %>%  #fixing hopeless cases that didn't work with regex
   mutate(fix_addr = replace(fix_addr, Record_ID == "recioiQBCA84JU2I3", "124-138 BLUE HILL AVE.")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recTyXOOlLb7UhjFu", "JULIUS RUBIN COURT")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recXp3Ne88xKIguTg", "47 SYLVAN ST")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recnOnDgLGM6o10E4", "14 KENNEY DRIVE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "reccxKoKRp2GMHGij", "1 GARDEN TERRACE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recZQNYvyGIpPCIMY", "10 RAINBOW TERRACE")) %>%   
   mutate(fix_addr = replace(fix_addr, Record_ID == "reciSma8eu6qX6Vw7", "7 PIONEER TERRACE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recMRLWSe0Uax4Sfv", "1 LIBERTY LANE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recBcZ9fB0vUdHZ1z", "1 LINCOLN PARK DRIVE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recQmXBKLok8VqZpu", "1 NORTON TERRACE"))  %>%
   mutate(fix_addr = replace(fix_addr, Record_ID == "recK680ySqStdZDnd", "100 FREMONT ST")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recuATtqLZ31RW9bU", "1 GORDON TERRACE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recUMuU6vjzpGL8Gk", "222 MORGAN STREET")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recpgu1fo8z1dv3RO", "11 B Trestle Way #1")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recWX3VNaCuEb2pH9", "3 Normandy Road")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recwvU8OUfExDSBou", "21 C St")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "rec5zJrIrxKrjY2Tr", "81 Orton Marotta Way")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "reci5qKjqi7ALbU0U", "1 SOL E MAR LANE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recs3Szq0vzBuZfbe", "25 WASHINGTON SQUARE")) %>% 
   #fixing Address NAs
   mutate(fix_addr = replace(fix_addr, Record_ID == "rec4lNuoE9jAxL3Rm", "18 POND STREET")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recWX3VNaCuEb2pH9", "Musterfield at Concord Place")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "rec5aEp3YMM6wZL8l", "Central Park Terrace")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "rece6afiIx1dOWiIA", "192 Brook Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recjUy5ScVgKi7nPx", "Pond View Village")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "rec8SKTnQ4Z1CJoay", "1 FOREST LANE")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recrswChrJGeu0ZHy", "3 Dewey Way")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recTNitsUik8hYBPc", "155 Marble Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recAlUBgJ4TI7uHql", "31 State Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recrzTbVYBN47LgSy", "80 Cedar Ave")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "rec4HzwhiH3ETE573", "194 Nahant Ave")) %>%
   mutate(fix_addr = replace(fix_addr, Record_ID == "recHvx467b7cOGIKK", "39 Aster Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recQ8YhnZRc3W7QFO", "Paul Bunker Drive")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recTNitsUik8hYBPc", "155 Marble Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recAlUBgJ4TI7uHql", "31 State Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recrzTbVYBN47LgSy", "80 Cedar Ave")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recHsV5TDeCgRj0bO", "Garden Lane")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recCUXUv9e5UCPInH", "50 Camden Street")) %>% 
   mutate(fix_addr = replace(fix_addr, Record_ID == "recZWSoSGmR0lUWpu", "80 Cedar Ave")) %>%    
   mutate(fix_addr = replace(fix_addr, Record_ID == "rec6Lw3fLcKVffdK4", "80 Cedar Ave"))
   

assets2 <- assets1 

# fixing special case A - B - C
assets2$fix_addr <- gsub("(A - B - C(\\s))", "", assets1$fix_addr)

# fixing hyphenated address ranges
assets2$fix_addr <- gsub("(-(\\s)?\\d+)", "", assets2$fix_addr)

# fixing other misc strings
assets3 <- assets2
assets3$fix_addr <- gsub("(&(\\s)?\\d+)|(AND(\\s)?\\d+)|/(\\s)?\\d+|(-(.*)(\\s)?)|(COMMUNITY(\\s.*)?\\d+)", "", assets2$fix_addr)

assets3$fix_addr <- sub("\\s+$", "",  assets3$fix_addr)

#ck
ck <- assets3 %>% 
  select(c(Record_ID,Address,City,fix_addr))

#cleanup
rm(assets1,assets2,ck)

## FIX ZIP CODES WITH LEADING ZERO and CONCAT CLEAN ADDRESSES
clean_addr <- assets3 %>% 
  mutate(fix_zip = as.character(str_pad(Zip, width = 5, side = c("left"), pad = 0))) %>% 
  mutate(concat_addr = as.character(paste0(fix_addr,", ",City," ",fix_zip)))
         

#geocode addresses
first_pass <- clean_addr %>% 
  geocode(address = 'concat_addr', method = 'arcgis') 

# export raw version to csv
write_csv(first_pass, paste0(exp_path,"State_Subs_Public_Housing_first_pass_geocode.csv"))

# sanity check existing x, y values
trim_na <- first_pass %>% 
  filter(!is.na(lat) & !is.na(long))

# remove three problem rows for now
trim <- subset(trim_na, !(Record_ID %in% c("recLKI6Z6Tt65AqCq", "recjUy5ScVgKi7nPx", "recYX1Wn3eU3S0vgA")))

# cast x,y to spatial df
assets_geo_sf <- trim %>% 
  st_as_sf(coords = c("long", "lat"), crs=4326)

#ck plot
ggplot(assets_geo_sf) + geom_sf()

# 3 points are below 40N... rm them first above line 121


#redo with nominatum
#rename cols for redo with osm
trim <- trim %>% 
  mutate(orig_lat = Lat) %>% 
  mutate(orig_long = Long) %>% 
  select(-c(Lat,Long))

trim <- trim %>% 
  mutate(esri_lat = lat) %>% 
  mutate(esri_long = long) %>% 
  select(-c(lat,long))

#ADD STATE to ADDRESS !!

ma_addr <- trim %>% 
  select(-c(concat_addr)) %>% 
  mutate(concat_addr = as.character(paste0(fix_addr,", ",City,", ",state," ",fix_zip)))


osm_geocode <- ma_addr %>%
  geocode(address = 'concat_addr', method = 'osm')


#  use the esri results for the 100 rows in osm that are blank
osm_patch <- osm_geocode %>% 
  mutate(across(lat, ~ifelse(is.na(.),esri_lat,.))) %>% 
  mutate(across(long, ~ifelse(is.na(.),esri_long,.)))


# setting errors in OSM to NA then fill with esri
# set lat to NA
osm_patch <- osm_patch %>% mutate(lat = replace(lat, Record_ID %in% c(
     "rechuNKjky2k9QiDK",
     "recqMlDPCgM613q5h",
     "recRdpZ2fjTgDXzmF",
     "recRGd99k6ehoSCr8",
     "recITJvv9ht30UEmF",
     "recIq9j3SyJlSrZVg",
     "recxKlMUDfSywA38E",
     "recNa4bEgmGLAZtb5", 
     "recMbPG4PaPjzexG6", 
     "recGN7NPPlPuqAEaq"), NA))
#set long to NA
osm_patch <- osm_patch %>% mutate(long = replace(long, Record_ID %in% c(
  "rechuNKjky2k9QiDK",
  "recqMlDPCgM613q5h",
  "recRdpZ2fjTgDXzmF",
  "recRGd99k6ehoSCr8",
  "recITJvv9ht30UEmF",
  "recIq9j3SyJlSrZVg",
  "recxKlMUDfSywA38E",
  "recNa4bEgmGLAZtb5", 
  "recMbPG4PaPjzexG6", 
  "recGN7NPPlPuqAEaq"), NA))

# another
osm_patch <- osm_patch %>% mutate(lat = replace(lat, Record_ID %in% c(
  "recxKlMUDfSywA38E"), NA))
#set long to NA
osm_patch <- osm_patch %>% mutate(long = replace(long, Record_ID %in% c(
  "recxKlMUDfSywA38E"), NA))


# new bedford
osm_patch <- osm_patch %>% mutate(lat = replace(lat, Record_ID %in% c(
  "recVmD8FoQU5PJiMG",
  "recU1cMQkgYzLqmRe",
  "recU154O1DOCsLWCy",
  "recU3hVT6LxZgA5Go",
  "recU5PTTtIpktyrpd",
  "recU832hBMHm4sw4j"), NA))
#set long to NA new bedford
osm_patch <- osm_patch %>% mutate(long = replace(long, Record_ID %in% c(
  "recVmD8FoQU5PJiMG",
  "recU1cMQkgYzLqmRe",
  "recU154O1DOCsLWCy",
  "recU3hVT6LxZgA5Go",
  "recU5PTTtIpktyrpd",
  "recU832hBMHm4sw4j"), NA))




# use esri again to patch the errors set back to NA
osm_patch <- osm_patch %>% 
  mutate(across(lat, ~ifelse(is.na(.),esri_lat,.))) %>% 
  mutate(across(long, ~ifelse(is.na(.),esri_long,.)))

# cast x,y to spatial df for osm
osm_geo_sf <- osm_patch %>% 
  st_as_sf(coords = c("long", "lat"), crs=4326)

st_crs(osm_geo_sf)

#ck plot
ggplot(osm_geo_sf) + geom_sf()


#write shapefile
write_sf(osm_geo_sf, paste0(exp_path,'State_Subs_Public_Housing_osm_2024-04-23.shp'))
