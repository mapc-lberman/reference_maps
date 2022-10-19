# Parcel Regions - Lists of Muni IDs by region

the shapefile for all MA parcels is too large for downloading, so it has been divided into three regions.

_Metrofuture_  Boston Metro Area and North Shore

_Southeast_ South Shore and Cape Cod

_West_ Central and Western MA

For convenience in joining with other data by Muni ID, the Parcel Regions files contain the list of Muni_IDs and Muni Names that relate to each of these regions.

Geojson files as reference maps are included (projection: EPSG 4326)


# Code for deriving the lists of Muni IDs by region

The original Parcels (polygon shapefiles) for each of the regions are available for download on Datacommon:

_Metro Boston Region_: https://datacommon.mapc.org/browser/datasets/359

_Southeast_: https://datacommon.mapc.org/browser/datasets/359

_West_: https://datacommon.mapc.org/browser/datasets/358


__Parcel_regions_by_muni.R__  script for extracting muni_ids from orignal csv files (which are > 1GB in size).  imports only the muni_id and muni names, then finds the distinct values and exports them to the .csv files in this folder (parecels_metro.csv, parcels_se.csv, parcels_west.csv).  (Note, these are not parcel level data, they contain the lists of MUNI_IDs that correspond the the parcel regions.)