library(dplyr)
library(tidycensus)

# R TUTORIAL FOR DATACOMMON

# see API documentation:
# https://mapc.github.io/datacommon-api-explorer/
# by Zoe Lu


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


# 2  test cases from R API
#  https://mapc.github.io/datacommon-api-explorer/

# Install jsonlite if you don't have it yet
install.packages("jsonlite")

# Load the library
library(jsonlite)

# API URL
url <- "https://datacommon.mapc.org/api/?token=datacommon&database=ds&query=SELECT+muni%2C+park_dem%2C+util_rate%2C+bldg_affp%2C+walk_score+FROM+tabular.trans_perfect_fit_parking+WHERE+muni+LIKE+%27Boston%27"

# Read JSON directly into a data frame
response <- fromJSON(url)

# Extract data and fields
data <- response$rows
fields <- response$fields

# View results
str(data)
head(data)
print(fields)

# Convert to data frame for analysis
df <- as.data.frame(data)

# Example analysis
summary(df)

### query on phase col

# Install jsonlite if you don't have it yet
install.packages("jsonlite")

# Load the library
library(jsonlite)

# API URL
url <- "https://datacommon.mapc.org/api/?token=datacommon&database=ds&query=SELECT+muni%2C+park_dem%2C+util_rate%2C+bldg_affp%2C+walk_score+FROM+tabular.trans_perfect_fit_parking+WHERE+muni+LIKE+%27Salem%27%0A"

# Read JSON directly into a data frame
response <- fromJSON(url)

# Extract data and fields
data <- response$rows
fields <- response$fields

# View results
str(data)
head(data)
print(fields)

# Convert to data frame for analysis
df <- as.data.frame(data)

# Example analysis
summary(df)

# try phase column


# API URL
url <- "https://datacommon.mapc.org/api/?token=datacommon&database=ds&query=SELECT+muni%2C+park_dem%2C+util_rate%2C+bldg_affp%2C+walk_score%2C+phase+FROM+tabular.trans_perfect_fit_parking+WHERE+phase+LIKE+%27phase+5%27%0A"

# Read JSON directly into a data frame
response <- fromJSON(url)

# Extract data and fields
data <- response$rows
fields <- response$fields

# View results
str(data)
head(data)
print(fields)

# Convert to data frame for analysis
df <- as.data.frame(data)

# Example analysis
summary(df)
