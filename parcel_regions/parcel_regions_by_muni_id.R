library(data.table)
library(dplyr)

## subsets of the Parcel Spatial Database by Region
## outputs csv containing the muni_id and muni names within the three regions

#set import / output folder
folder = "C:/Users/MAPCStaff/Desktop/MAPC/0_PROJECTS/2022_parcels/regions_guide_map/"


## Metro Boston Region

# data src: https://datacommon.mapc.org/browser/datasets/359

parcel_muni_metro <- fread(paste0(folder,"/mapc.ma_parcels_metrofuture.csv"),  # Import columns
                      select = c("muni_id", "muni"))

p_metro = parcel_muni_metro  %>%
  group_by(muni_id) %>%
  select(muni_id, muni) %>%
  unique()

p_metro %>% arrange(muni) %>% 
  write.csv(.,(paste0(folder,"/parcels_metro.csv")))



## Southeast Region

# data src: https://datacommon.mapc.org/browser/datasets/359

parcel_muni_southeast <- fread(paste0(folder,"/mapc.ma_parcels_southeast.csv"),  # Import columns
                           select = c("muni_id", "muni"))

p_se = parcel_muni_southeast  %>%
  group_by(muni_id) %>%
  select(muni_id, muni) %>%
  unique()

p_se  %>% arrange(muni) %>% 
  write.csv(.,(paste0(folder,"/parcels_se.csv")))


## West Region

# data src: https://datacommon.mapc.org/browser/datasets/358

parcel_muni_west <- fread(paste0(folder,"/mapc.ma_parcels_west.csv"),  # Import columns
                               select = c("muni_id", "muni"))

p_west = parcel_muni_west  %>%
  group_by(muni_id) %>%
  select(muni_id, muni) %>%
  unique()

p_west %>% arrange(muni) %>% 
  write.csv(.,(paste0(folder,"/parcels_west.csv")))


