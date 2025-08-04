#smooth polygon
# see https://www.r-bloggers.com/2021/03/simplifying-geospatial-features-in-r-with-sf-and-rmapshaper/
# packages
library(sf)
library(ggplot2)
library(dplyr)

ma_poly <- read_sf("C:/Users/lberman/Desktop/ArcGIS/AGOL_edits/ma_outline_25k_ExportFeature.shp")

st_crs(ma_poly)

# adjust buffer value (in map units) ie 100 m or 200 meters, etc
# the first buffer shrinks, the second re-expands (having removed vertices)
ma_poly_buf_neg <- st_buffer(ma_poly, -100, nQuadSegs = 1) %>%
  st_buffer(100, nQuadSegs = 1)

plot(ma_poly_buf_neg)

ma_poly_buf_neg <- ma_poly_buf_neg %>% 
  mutate(Shape_Area = 2096384) %>% # had to explicitly shorten a value to enable export
  select(-c(st_area_sh,st_length_))  #had to remove redundant cols to enable export

st_write(ma_poly_buf_neg, "C:/Users/lberman/Desktop/ArcGIS/AGOL_edits/MA_state_outline_smooth_100m.shp")
