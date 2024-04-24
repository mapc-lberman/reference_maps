# Geocoding for Multi-Family Buildings

__source__:  [Airtable: State Subsidized Public Housing - DEV](https://airtable.com/appOJcXh3ZWTq3UY7?)

use the View called "All Fields"

__process__:  using regex and hand-coded edits to clean up the table for geocoding.   The tidygeocoder package is used, with method = 'esri'

errors and omissions in the geocoding.  were patched with corrected addresses.   all the x, y were preserved in the output shapefile.  the orig_lat, orig_long, were those already in the Airtable. the lat, long were produced with the tidygeocoder method = "esri".   

the output shapefile is from the result of esri geocoder, overlayed with Census Tract boundaries to obtain the ct20_id

__output__:  see output shapefile at:  

_K:\DataServices\Datasets\Housing\Multi_Family_Building_Locations\output_

__State_Subs_Public_Housing_ESRI_geocode.csv__

__State_Subs_Public_Housing_GEOCODE_2024-04-24.shp__





