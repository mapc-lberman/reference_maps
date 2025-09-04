library(dplyr)
library(tidycensus)

# R TUTORIAL FOR DATACOMMON
# lberman 2024-06-27
# revised for new API factors 2025-09-04

### 0. SETUP VARIABLES SECTION

# 0.1 INPUT ACS 5YR VALUE for ACS tables
# some tables do not have YEAR option

input_year = "2018-22,2011-15"

# 0.2 PATH TO OUTPUT FOLDER 
# write table to exp_path
# exp_path = "H:/0_PROJECTS/project/output/"


## READ CSV FROM DATACOMMON INTO R DF

## Find a Dataset to import at https://datacommon.mapc.org/
## Select a single year, or multiple years of data using the interface
## Right-Click on the top right button labeled ".csv" and COPY THE LINK


## create a statement to read_csv into R using the API syntax described below

## note: the following syntax is obsolete after launching a new version of DataCommon on 2025-09-01
## df <- read.csv(paste0("https://datacommon.mapc.org/csv?table=tabular.TABLE-NAME&database=ds&years="YEARS,SELECTED"&year_col=acs_year"))

## API examples

## the required facets for the request:
## token=datacommon
## database=ds
## schema=tabular
## table={table_name}

###
## 1. import single year of data directly from one DataCommon table
# (example: Housing Units by Tenure)
get_b25127 <- read.csv(paste0("https://datacommon.mapc.org/api/export?token=datacommon&database=ds&schema=tabular&table=b25127_hu_tenure_year_built_units_acs_m&format=csv&years=",input_year))


## 1.2 import multiple years of data directly from one DataCommon table
get_multi_b25127 <- read.csv(paste0("https://datacommon.mapc.org/api/export?token=datacommon&database=ds&schema=tabular&table=b25127_hu_tenure_year_built_units_acs_m&format=csv&years=",input_year))


## 1.3 import table that does NOT have ACS year column defined
get_perf <- read.csv("https://datacommon.mapc.org/api/export?token=datacommon&database=ds&schema=tabular&table=trans_perfect_fit_parking&format=csv")

