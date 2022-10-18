# Parcel Regions - Lists of Muni IDs by region

the shapefile for all MA parcels is too large for downloading, so it has been divided into three regions.

_Metrofuture_  Boston Metro Area and North Shore

_Southeast_ South Shore and Cape Cod

_West_ Central and Western MA

For convenience in joining with other data by Muni ID, the Parcel Regions files contain the list of Muni_IDs and Muni Names that relate to each of these regions.

Shapefiles of Muni Boundaries, and reference maps are included.

shapefile in MAPC projection: CPSG 26986
PROJCRS - "NAD83 / Massachusetts Mainland"


# Code for deriving the lists of Muni IDs by region

The original Parcel Data for each of the regions is available on Datacommon:

__Metro Boston Region__: https://datacommon.mapc.org/browser/datasets/359

__Southeast__: https://datacommon.mapc.org/browser/datasets/359

__West__: https://datacommon.mapc.org/browser/datasets/358

Parcel_regions_by_muni.R  imports only the muni_id and muni names, then finds the distinct values and exports them to the .csv files in this folder (parecels_metro.csv, parcels_se.csv, parcels_west.csv).  Note, these are not parcel level data, but the lists of MUNI_IDs that correspond the the parcel regions.