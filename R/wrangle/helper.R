####################################
# Title: Wrangling Helpers
# Author: Dantz Farrow
# Last Modified: 07/02/2026
####################################

# Calculate mode
get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
