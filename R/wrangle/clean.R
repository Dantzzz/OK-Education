####################################
# Title: Clean NCES Data
# Author: Dantz Farrow
# Last Modified: 07/01/2026
####################################

clean_nces <- function(file) {
  # replace en-dash (unicode) w/ NAs on load
  read_csv(file, na = c("", "NA", "\u2013")) %>%
    # trim whitespace
    mutate(operational_status = str_trim(operational_status)) %>%
    # filter out closed/annexed districts
    filter(operational_status == "Open") %>%
    # enforce dtypes
    mutate(across(fips:district, as.character)) %>%
    mutate(across(enroll_0108:title_i, as.numeric)) %>%
    # drop unnecessary columns
    select(-state, -lea_charter)
}

clean_seda <- function(file) {
  read_csv(file) %>%
    filter(
      stateabb == "OK",
      subcat   == "all"
    ) %>%
    mutate(sedaadmin = as.character(sedaadmin)) %>%
    select(sedaadmin, year, cs_mn_avg_ol, cs_mn_avg_ol_se)
}
