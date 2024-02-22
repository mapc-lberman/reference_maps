library(rgdal) 
library(dplyr) 
library(RSQLite)
library(sf)
library(tidyverse)
# see 
# https://olalladiaz.net/blog/2018/11/02/working-with-gpkg-r/
# http://web.archive.org/web/20190720064857/http://jsta.github.io/2016/07/14/geopackage-r.html

# setwd on VM
setwd("K:/dataservices/DataSets/Transportation/UMN_accessibility_observatory/2019")

# setwd on DELL
#setwd("S:/Network Shares/NEW K Drive/dataservices/DataSets/Transportation/UMN_accessibility_observatory/2019")

# set up spatial south
gpkgSouth = "39300_Providence-New Bedford-Fall River_RI-MA/39300_tr_2019_0700-0859-avg.gpkg"

# set up spatial north
gpkgNorth = "14460_Boston-Cambridge-Quincy_MA-NH/14460_tr_2019_0700-0859-avg.gpkg"


# Explore the layers available 
ogrListLayers("39300_Providence-New Bedford-Fall River_RI-MA/39300_tr_2019_0700-0859-avg.gpkg")

# fieldname_descriptions
southFields <- src_sqlite ("39300_Providence-New Bedford-Fall River_RI-MA/39300_tr_2019_0700-0859-avg.gpkg") 
southdataFields <- tbl (southFields, "fieldname_descriptions") #Create a table from a data source
southFieldsdf <- as.data.frame (southdataFields) #Create a data frame

#import south tabular data layer for selected time interval
south <- src_sqlite ("39300_Providence-New Bedford-Fall River_RI-MA/39300_tr_2019_0700-0859-avg.gpkg") 
southdata <- tbl (south, "tr_45_minutes") #Create a table from a data source
southdf <- as.data.frame (southdata) #Create a data frame


ogrListLayers("14460_Boston-Cambridge-Quincy_MA-NH/14460_tr_2019_0700-0859-avg.gpkg")

#import north tabular data layer for selected time interval
north <- src_sqlite ("14460_Boston-Cambridge-Quincy_MA-NH/14460_tr_2019_0700-0859-avg.gpkg") 
northdata <- tbl (north, "tr_45_minutes") #Create a table from a data source
northdf <- as.data.frame (northdata) #Create a data frame

#ck col names in tables for non-matching cols
northdf[setdiff(names(northdf), names(southdf))]

# ck content
# head(southdf)
# head(northdf)

massdf <- rbind(southdf, northdf)

# get spatial data 
blocksNorth <- st_read(gpkgNorth, layer = "blocks")
blocksSouth <- st_read(gpkgSouth, layer = "blocks")

class(blocksNorth)

st_crs(blocksNorth)
st_crs(blocksSouth)

massBlocks <- bind_rows(blocksNorth, blocksSouth)

tail(massBlocks)


join = massBlocks %>% left_join(massdf,by="blockid")

st_crs(join)

head(join)

join$prefix <- substr(join$blockid, 1, 2)

head(join)

join_ma <- join %>% filter(prefix == "25")

## export to shp
st_write(join_ma, paste0("merged_shp/mass_blocks_45min.shp"))
