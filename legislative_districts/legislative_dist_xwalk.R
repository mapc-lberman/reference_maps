library(readr)
library(mapcdatakeys)

## Legislative Districts to Towns Crosswalk
## research:  Mike Bond
## 2025-01-31

## crosswalks 
# legis_xwalk_HOUSE.csv
# legis_xwalk_SENATE.csv

## list of current office holders
# legislators_HOUSE.csv
# legislators_SENATE.csv


## UPDATE PATH TO .CSV
leg_path = "H:/0_PROJECTS/2025_data_keys/legislative_districts/"

get_keys <- mapcdatakeys::all_muni_data_keys

keys_upper <- get_keys %>% 
  select(c(muni_id,muni_name,muni_upper))


## get xwalk for HOUSE

house <- read_csv(paste0(leg_path,'legis_xwalk_HOUSE.csv')) %>% 
  mutate(muni_ck = muni_name) %>% 
  select(-c(muni_name))

house_key <- house %>% 
  left_join(.,
            keys_upper %>% select(c(muni_id,muni_name,muni_upper)),
            by = c('muni_ck' = 'muni_upper')) %>% 
  select(-c(muni_ck)) %>% 
  mutate(muni_id = as.character(muni_id))


## get office-holders for HOUSE

house_info <- read_csv(paste0(leg_path,'legislators_HOUSE.csv'))

## join of all HOUSE info with muni-key IDs
house_w_reps <- house_key %>% 
  left_join(.,
            house_info,
            by = c('houdist_id' = 'DIST_CODE'))


## example query  find all house districts for Boston

boston_house_reps <- house_w_reps %>% 
  filter(muni_id == 35)



## get xwalk for SENATE

senate <- read_csv(paste0(leg_path,'legis_xwalk_SENATE.csv')) %>% 
  mutate(muni_ck = muni_name) %>% 
  select(-c(muni_name))

senate_key <- senate %>% 
  left_join(.,
            keys_upper %>% select(c(muni_id,muni_name,muni_upper)),
            by = c('muni_ck' = 'muni_upper')) %>% 
  select(-c(muni_ck)) %>% 
  mutate(muni_id = as.character(muni_id))

## get office-holders for SENATE

senate_info <- read_csv(paste0(leg_path,'legislators_SENATE.csv'))

## join of all HOUSE info with muni-key IDs
senate_w_reps <- senate_key %>% 
  left_join(.,
            senate_info,
            by = c('sendist_id' = 'SENDISTNUM'))

## example query  find all senate districts for Springfield

springf_senate_reps <- senate_w_reps %>% 
  filter(muni_id == 281)
