# Geocoding for Multi-Family Buildings

__source__:  [Airtable: State Subsidized Public Housing - DEV](https://airtable.com/appOJcXh3ZWTq3UY7?)

use the View called "All Fields"

__process__:  using regex and hand-coded edits to clean up the table for geocoding.   The tidygeocoder package is used, first with method = 'esri' then with method = 'osm'

the OSM accuracy was better when examined for spot locations.   however, there were some errors and omissions in the osm geocoding.  these were replaced by NA, then filled in with the esri geocoded results.   all the x, y were preserved in the output shapefile.  the orig_lat, orig_long, were those already in the Airtable.  the esri_lat, esri_long, osm_lat, and osm_long were produced with the tidygeocoder.   the output shapefile is from the result of osm geocoder, patched by some esri results for missing and erroneous points (amounting to about 150 items in all).

__output__:  see output shapefile at:  

_K:\DataServices\Datasets\Housing\Multi_Family_Building_Locations\output_

__State_Subs_Public_Housing_osm_2024-04-23.shp__





