# archive pums from tidycensus

# 2025-02-04

# see https://walker-data.com/tidycensus/articles/pums-data.html


#install.packages(c("survey", "srvyr"))library(tidyverse)

library(tidyverse)
library(tidycensus)
library(dplyr)

# set output folder
output = "K:/DataServices/Code/Python/Python_ACS_Script/censusdis_backup_test/pums/"

# if running repeatedly, clear objects first
rm(pums_vars,uniq,uniq_pers_vars,ma_pums)

# enter year to archive
data_year <- 2019

# get all vars for data year
pums_vars <- pums_variables %>% 
  filter(year == data_year, survey == "acs5")

# show unique vars (not with all possible value permutations)
uniq <- pums_vars %>% 
  distinct(var_code, var_label, data_type, level)

# show person only vars
uniq_pers_vars <- pums_vars %>% 
  distinct(var_code, var_label, data_type, level) %>% 
  filter(level == "person")

# get the var_code column as a list for the data request
# CODE CRASHED WHEN PULLING THIS COMPLETE LIST
#pums_var_list <- uniq %>% 
#  pull(var_code)


# statewide list

# person vars
var.list  <- c('AGEP',
               'DDRS', # added 16 Sep
               'DIS',
               'DEAR', # added 16 Sep
               'DEYE', # added 16 Sep
               'DOUT', # added 16 Sep
               'DPHY', # added 16 Sep
               'DREM', # added 16 Sep
               'ENG',
               'HISP',
               'LANX',
               'NATIVITY',
               'OC',
               'POBP',
               'RAC1P',
               'RAC2P',
               'RELSHIPP',
               'SCH',
               'SCHG',
               'SCHL',
               'SEX',
               'SFN',
               'SFR',
               'WAOB',
               'YOEP',
               'ADJHSG',
               'ADJINC',
               'BDSP',
               'BLD',
               'CPLT',
               'GRNTP',
               'GRPIP',
               #'HHLDRAGEP',
               #'HHLDRHISP',
               #'HHLDRRAC1P',
               'HHT',
               'HHT2',
               'HINCP',
               'HUGCL',
               'HUPAC',
               'HUPAOC',
               'HUPARC',
               'LNGI',
               'MULTG',
               'MV',
               'NP',
               'NPF',
               'NPP',
               'NR',
               'NRC',
               'OCPIP',
               'PARTNER',
               'PSF',
               'R18',
               'R60',
               'R65',
               'RMSP',
               'RT',
               'SMOCP',
               'SRNT',
               'SVAL',
               'TEN',
               'TYPEHUGQ',
               'VACS',
               'VEH',
               #'YRBLT',
               'PUMA')



ma_pums <- get_pums(
  variables = var.list,
  state = "MA",
  survey = "acs5",
  year = data_year
)

names <- names(ma_pums)
names_df <- as.data.frame(names)

write_csv(ma_pums, paste0(output, "pums_backup_statewide_", data_year, ".csv"))

write_csv(names_df, paste0(output, "pums_backup_statewide_", data_year, "_vars.csv"))
