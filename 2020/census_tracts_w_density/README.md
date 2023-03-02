# Census Tracts w/ density

There are two new versions of "density" maps on K Drive for MA Census Tracts

1. tracts_w_density
2. tracts_no_water

These were created in R using the spatial data: MAPC Census Tracts Basemap for 2020, joined to the Decennial Census 20202 variables for Total Population, Total Housing Units, Occupied Housing Units, and Vacant Housing Units.  The raw variables and Census Variable names:

 - pop = "P1_001N", 
 - hu = "H1_001N", 
 - hu_occ = "H1_002N", 
 - hu_vac = "H1_003N"

The density calculations are based on the column:  ALAND (area of land) which is part of the original MAPC CENSUS TRACTS shapefile, and the units are square meters

First, the ALAND figure is converted to Square Miles (area_sqMi) and Acres (area_Acre)

Second, the density calculations are made by dividing the four census variables by area_sqMi

The output:  

K:\DataServices\Datasets\Boundaries\Spatial\CENSUS2020_TRCT_SHP\tracts_w_density

2020_mapc_tracts_density_20230301.shp

---

Another version was created using the erase_water() function.

This function will remove the water bodies from the spatial data polygons, based on an "area_threshold" setting.  The setting used was .6, which means that the larger water bodies (60th percentile in size and up) will be erased and the resulting polygons will have "donut holes" where those water bodies occur.

A calculation was made to find the area_sqm based on the polygons with the water erased.  The results were compared with the original ALAND value, and demonstrated that ALAND is actually the correct value when all the water polygons removed from the polygons.  

The dataset with the .6 water bodies was saved for mapping / visualization purposes:

K:\DataServices\Datasets\Boundaries\Spatial\CENSUS2020_TRCT_SHP\tracts_w_density

2020_mapc_tracts_no-wtr_20230301.shp


Use the R scripts if you wish to join other Census Variables to the same Census_tracts Basemap, or to create a new version with erase_water() area_threshold values other than .6.   

NOTE:  change the output dataset filename at the end of the script to prevent overwriting the existing DENSITY shapefiles.