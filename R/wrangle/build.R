####################################
# Title: Build Data Set
# Author: Dantz Farrow
# Last Modified: 07/03/2026
# Description: This script contains functions
# for loading, merging, and saving initial data set.
# To begin here, download the SEDA data file inside data/raw/.
# Otherwise... {}
####################################

# -- Load
load_nces <- function(file) {
  # replace en-dash (unicode) w/ NAs on load
  read_csv(file, na = c("", "NA", "\u2013")) %>%
    mutate(operational_status = str_trim(operational_status)) %>% # trim whitespace
    filter(operational_status == "Open") %>% # remove closed/annexed districts
    # enforce dtypes
    mutate(across(fips:district, as.character)) %>%
    mutate(across(enroll_0108:title_i, as.numeric)) %>%
    select(-state, -lea_charter, -operational_status) # drop unnecessary cols
}

load_seda <- function(file) {
  read_csv(file) %>%
    filter(
      stateabb == "OK", # filter to OK
      subcat   == "all" # discard dem/econ stratification
    ) %>%
    mutate(sedaadmin = as.character(sedaadmin)) %>% # enforce dtype
    select(-sedaadminname, -fips, -stateabb, -subcat, -subgroup)
}

# -- Merge
build_panel <- function(x, y) {
  left_join(x, y, by = c("fips" = "sedaadmin", "year"))
}

# -- Save
write_panel <- function(data, path){
  dir.create(dirname(path), recursive = T, showWarnings = T)
  write_rds(data, path)
  path
}
