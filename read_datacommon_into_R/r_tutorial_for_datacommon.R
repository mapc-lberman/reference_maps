library(dplyr)
library(tidycensus)

# R TUTORIAL FOR DATACOMMON
# lberman 2024-06-27
# 

### 0. SETUP VARIABLES SECTION

# 0.1 INPUT ACS 5YR VALUE
# input_year = "2018-22"

# 0.2 PATH TO OUTPUT FOLDER 
# write table to exp_path
# exp_path = "H:/0_PROJECTS/project/output/"


## READ CSV FROM DATACOMMON INTO R DF

## Find a Dataset to import at https://datacommon.mapc.org/
## Select a single year, or multiple years of data using the interface
## Right-Click on the top right button labeled ".csv" and COPY THE LINK
## create a statement to read_csv into R using the syntax:

## df <- read.csv(paste0("https://datacommon.mapc.org/csv?table=tabular.TABLE-NAME&database=ds&years="YEARS,SELECTED"&year_col=acs_year"))
## as in the following examples

###
## 1. import single year of data directly from one DataCommon table
# (example: Housing Units by Tenure)

get_b25127 <- read.csv(paste0("https://datacommon.mapc.org/csv?table=tabular.b25127_hu_tenure_year_built_units_acs_m&database=ds&years=",input_year,"&year_col=acs_year"))


###
## 1. import multiple years of data directly from one DataCommon table
# (example: mortgage denials by race (municipality))

get_hmda <-  read.csv("https://datacommon.mapc.org/csv?table=tabular.hmda_mortgage_denials_by_race_120k_m&database=ds&years=2022,2021,2020,2019,2018&year_col=year")
