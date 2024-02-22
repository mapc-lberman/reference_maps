# UMN Accessibility Observatory data

__developers:__

Lex Berman  

__current version:__

revised version in 2021:  

_K:\DataServices\Datasets\Transportation\UMN_accessibility_observatory_

__umn_transit_access_ingest_2021.R__


__usage overview__

1.  Download data for Massachusetts (contains five .csv at different geographic levels)
2.  base url: https://conservancy.umn.edu/handle/11299/256251
3.  see the ingest R script in the /analysis folder for 2021
4.  the script will ingest Census Tracts and output a join to tract polygons
5.  two .shp are exported, one for the state, one for MAPC region
4.  the data contain weighted averages of transit access at 5 minute intervals (in seconds) ["threshold"]
5.  the sample script filters the data to 45 min threshold (set in the ["min"] variable)


_edits:  lberman@mapc_
updated Feb 2024