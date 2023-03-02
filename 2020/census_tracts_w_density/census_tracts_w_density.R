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

plot(tracts_base['ALAND'])

join1 <-merge(tracts_base, tracts_ma, by = "GEOID", all = TRUE)

plot(join1['hu_vac'])

st_crs(join1)

# reset EPSG:26986 transform to NAD83 / Massachusetts Mainland, units meters
tracts_proj <- join1 %>%
  st_transform(26986)
st_crs(tracts_proj)

## this version does not remove any water bodies from the polgyons
# see census_tracts_w_density_water_removed.R  if you want to ERASE the water bodies

# use ALAND to calculate area in sqMi (square miles) and sqAc (square acres)

#formula for area calculations from https://www.checkyourmath.com/convert/area/square_m.php
tracts_proj$area_sqMi <- (tracts_proj$ALAND/2589988.11)
tracts_proj$area_Acre <- (tracts_proj$ALAND/4046.85642)

# for convenience we pre-calculate cols for pop/sqMi, hu/sqMi, hu_occ/sqMi, hu_vac/sqMi
tracts_proj$pop_sqMi <- (tracts_proj$pop/tracts_proj$area_sqMi)
tracts_proj$hu_sqMi <- (tracts_proj$hu/tracts_proj$area_sqMi)
tracts_proj$occ_sqMi <- (tracts_proj$hu_occ/tracts_proj$area_sqMi)
tracts_proj$vac_sqMi <- (tracts_proj$hu_vac/tracts_proj$area_sqMi)

# convert numeric to decimal cols
tracts_proj$area_sqMi <- round(tracts_proj$area_sqMi, digits = 3)
tracts_proj$area_Acre <- round(tracts_proj$area_Acre, digits = 3)
tracts_proj$pop_sqMi <- round(tracts_proj$pop_sqMi, digits = 3)
tracts_proj$hu_sqMi <- round(tracts_proj$hu_sqMi, digits = 3)
tracts_proj$occ_sqMi <- round(tracts_proj$occ_sqMi, digits = 3)
tracts_proj$vac_sqMi <- round(tracts_proj$vac_sqMi, digits = 3)

#CHANGE THE OUTPUT SHAPEFILE NAME FOR UPDATED VERSIONS
st_write(tracts_proj, "2020_mapc_tracts_density_20230301_XYZ.shp")
