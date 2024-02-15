ma_house_district_to_muni_index

FILE:
K:\DataServices\Datasets\Civic Vitality and Governance\Spatial\MA_HOUSE2021\ma_senate_district_to_muni_index.csv

DESC:  cross index of senate legislative districts to MAPC Municipality IDs

SOURCES:

1. Mass Senate District Polygons 2021 from MassGIS (went into effect for 2022 elections)
https://www.mass.gov/info-details/massgis-data-massachusetts-senate-legislative-districts-2021

2. MA Municipality boundaries
K:\DataServices\Datasets\Boundaries\Municipal\ma_municipalities_water_trim.shp


PROCESS:  

one-to-many spatial join, with one row for each District to municipality match.

SORT BY OBJECTID  to see each group of District Rows and which munis fall in each district.

SORT BY muni_id to see each group of Municipalities and which districts are overlapping the municipality.  (for example:  FRAMINGHAM overlaps these three senate districts: #14 Norfolk Worcester and Middlesex, #13 Middlesex and Norfolk, #12 Middlesex and Worcester).

