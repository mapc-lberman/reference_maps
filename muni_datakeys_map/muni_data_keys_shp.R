library(tidyverse)
library(sf)

df = read_sf("//Client/C$/Users/MAPCStaff/Desktop/SWAP/SHP/ma_muni_for_datakeys.shp") %>% 
  select(!c(TOWN,SHAPE_AREA,SHAPE_LEN)) %>% rename(muni_id = TOWN_ID) %>% 
  left_join(.,mapcdatakeys::all_muni_data_keys %>% select(muni_id, muni_name)) %>% 
  mutate(across(.cols = c(muni_name, muni_id), .fns = as.character))
  
df %>% write_sf("//Client/C$/Users/MAPCStaff/Desktop/SWAP/SHP/muni_datakeys_shp_edited.shp")
