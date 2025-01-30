__Legislative Crosswalk Updates (1/30/25)__

_by Mike Bond_

This legislative crosswalk contains a list of legislative districts (House &  Senate), who represents them, their party, and the towns within that district. 

This was done in ArcGIS with the source data: MassGIS 2025 legislative district data and MAPC Massachusetts municipality data. 

Using the intersect tool, the towns within each legislative district were calculated and identified. This method is imperfect, as ArcGIS pro identified very slight overlaps on the boundaries of the districts and the towns that neighbor, but aren't included, in that district.  For example, Suffolk 10th district contains parts of Boston and Brookline, while bordering Newton and Needham. In the original crosswalk, it identified Brookline, Boston, Newton, and Needham as all being within that district, despite it being composed of one the first two.  ArcGIS identified the boundaries of these towns as part of the district. 

To eliminate the intersect errors, I went through the calculated intersection area for each district in the attribute table. Each intersecting area that was under 1000 sq ft was removed from the table, eliminating all the fragments erroneously identified as part of those districts. The result was a table with a list of each district and their corresponding town(s)

__post-processing__ 
_lex berman_

R version has been edited for one-to-one match between each district ID and each municipality ID.

The crosswalk between legislative districts and munis are separated into two tables:

_crosswalks_

legis_xwalk_HOUSE.csv

legis_xwalk_SENATE.csv

The information about current office-holders is split into two tables (so that these can be updated or changed indepedently of the district crosswalk over time.)

_list of current office holders_

legislators_HOUSE.csv

legislators_SENATE.csv

sample script of loading, joining and querying in R: 
 __legislative_dist_xwalk.R__