ma_house_district_to_muni_index

FILE:
K:\DataServices\Datasets\Civic Vitality and Governance\Spatial\MA_HOUSE2021\ma_house_district_to_muni_index.csv

DESC:  cross index of house legislative districts to MAPC Municipality IDs

SOURCES:

1. Mass House District Polygons 2021 from MassGIS (went into effect for 2022 elections)
https://www.mass.gov/info-details/massgis-data-massachusetts-house-legislative-districts-2021

2. MA Municipality boundaries
K:\DataServices\Datasets\Boundaries\Municipal\ma_municipalities_water_trim.shp


PROCESS:  

one-to-many spatial join, with one row for each District to municipality match.

SORT BY OBJECTID  to see each group of District Rows and which munis fall in each district.

SORT BY muni_id to see each group of Municipalities and which districts are overlapping the municipality.  (for example:  ABINGTON overlaps these five districts  PLY07, PLY10, NORFOLK03, PLY05, NORFOLK04).
