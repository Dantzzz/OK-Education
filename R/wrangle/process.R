####################################
# Title: Process Data (Merge + Transform)
# Author: Dantz Farrow
# Last Modified: 07/02/2026
####################################

### To Implement:
#generate_panels <- function(x, y) {
#  merge_left  <- left_join(x, y, by = c("fips" = "sedaadmin", "year"))
#  merge_inner <- inner_join(x, y, by = c("fips" = "sedaadmin", "year"))
#
#  return(list(merge_left, merge_inner))
#}

merge_left <- function(x, y) {
  left_join(x, y, by = c("fips" = "sedaadmin", "year"))
}

merge_inner <- function(x, y) {
  inner_join(x, y, by = c("fips" = "sedaadmin", "year"))
}
