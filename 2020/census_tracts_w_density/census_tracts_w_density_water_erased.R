library(tigris)
library(tidycensus)
library(tidyverse)
library(sf)
library(tidyr)
sessionInfo()

#2020 census tracts with pop and housing density

options(tigris_use_cache = TRUE)

getvars <- c(pop = "P1_001N", 
              hu = "H1_001N", 
              hu_occ = "H1_002N", 
              hu_vac = "H1_003N")

tracts_ma <- get_decennial(
  geography = "tract",
  variables = getvars,
  state = "MA",
  geometry = FALSE,
  year = 2020,
  output = "wide"
) 

# set Census vars to INTEGER
tracts_ma$pop <- as.integer(tracts_ma$pop)
tracts_ma$hu <- as.integer(tracts_ma$hu)
tracts_ma$hu_occ <- as.integer(tracts_ma$hu_occ)
tracts_ma$hu_vac <- as.integer(tracts_ma$hu_vac)

# Load shapefile
tracts_base <- read_sf('S:/Network Shares/NEW K Drive/DataServices/Datasets/Boundaries/Spatial/CENSUS2020_TRCT_SHP/CENSUS2020TRACTS_POLY.shp')

setwd("S:/Network Shares/H Drive/0_PROJECTS/2023_Density_pop_hu/shp/")

getwd()

no_wtr <- tracts_base %>%
  st_transform(3424) %>%
  erase_water(area_threshold = 0.6)

plot(no_wtr['ALAND'])

join1 <-merge(no_wtr, tracts_ma, by = "GEOID", all = TRUE)

plot(join1['hu_vac'])

st_crs(join1)

# transform to NAD83 / Massachusetts Mainland, units meters
no_wtr_proj <- join1 %>%
  st_transform(26986)
st_crs(no_wtr_proj)

## no_wtr_proj$area_sqm <- st_area(st_as_sf(no_wtr_proj))
# note, if we use the the calculated area_sqm on previous line, value is slightly larger than the ALAND value
# this is correct.  the ALAND value is the actual Land Area in Square Meters
# the calculated area_sqm is based on the erase_water() function set to .6 (60th percentile of water body size)
# therefore the ALAND number is proven accurate

# we can use ALAND to calculate area in sqMi (square miles) and sqAc (square acres)

#formula for area calculations from https://www.checkyourmath.com/convert/area/square_m.php
no_wtr_proj$area_sqMi <- (no_wtr_proj$ALAND/2589988.11)
no_wtr_proj$area_Acre <- (no_wtr_proj$ALAND/4046.85642)

# for convenience we pre-calculate cols for pop/sqMi, hu/sqMi, hu_occ/sqMi, hu_vac/sqMi
no_wtr_proj$pop_sqMi <- (no_wtr_proj$pop/no_wtr_proj$area_sqMi)
no_wtr_proj$hu_sqMi <- (no_wtr_proj$hu/no_wtr_proj$area_sqMi)
no_wtr_proj$occ_sqMi <- (no_wtr_proj$hu_occ/no_wtr_proj$area_sqMi)
no_wtr_proj$vac_sqMi <- (no_wtr_proj$hu_vac/no_wtr_proj$area_sqMi)


# convert numeric to decimal cols
no_wtr_proj$area_sqMi <- round(no_wtr_proj$area_sqMi, digits = 3)
no_wtr_proj$area_Acre <- round(no_wtr_proj$area_Acre, digits = 3)
no_wtr_proj$pop_sqMi <- round(no_wtr_proj$pop_sqMi, digits = 3)
no_wtr_proj$hu_sqMi <- round(no_wtr_proj$hu_sqMi, digits = 3)
no_wtr_proj$occ_sqMi <- round(no_wtr_proj$occ_sqMi, digits = 3)
no_wtr_proj$vac_sqMi <- round(no_wtr_proj$vac_sqMi, digits = 3)


setwd("S:/Network Shares/H Drive/0_PROJECTS/2023_Density_pop_hu/shp/")

getwd()

#CHANGE THE OUTPUT SHAPEFILE NAME FOR UPDATED VERSIONS
st_write(no_wtr_proj, "2020_mapc_tracts_no-wtr_20230301_XYZ.shp", append=FALSE)

