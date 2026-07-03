####################################
# Title: Stage Data Sets for Analysis
# Author: Dantz Farrow
# Last Modified: 07/03/2026
# Description: Contains functions for
# staging data for time-series and
# cross-sectional analysis
####################################

# --- Time-Series Staging ---

# --- Cross-Section Staging ---


stage_cs <- function(x){
  x %>%
    # reduce to inner join
    filter(!is.na(cs_mn_avg_ol)) %>%
    # replace na in PK-8
    mutate(enroll_0912 = replace_na(enroll_0912, 0)) %>%
    # sum enrollment in new col
    mutate(total_enrollment = enroll_0108 + enroll_0912) %>%
    # drop features
    select(
      -locale_class, -lat, -lon, -enroll_0912,
      -multi_comp:-flag_estasmt, -cs_mn_avg_eb:-cs_mn_avg_eb_se_adj) %>%
    # select & rename features
    select(
      fips:title_i,
      total_enrollment,
      cs_score        = cs_mn_avg_ol,
      cs_score_se     = cs_mn_avg_ol_se,
      -year)
  # NOTE:
  # `stage_cs` is nested within `collapse_cs`.
  # Edit stage for feature selection & removal
  # Must retain fips, cs_score, cs_score_se, enroll_0108,
  # and total_enrollment for `collapse_cs`.

}

collapse_cs <- function(x){
  x %>%
    # defined above
    stage_cs() %>%
    group_by(fips) %>%
    summarise(
      # precision-weighted, not flat mean
      cs_score    = weighted.mean(cs_score, w = 1 / cs_score_se^2),
      cs_score_se = sqrt(1 / sum(1 / cs_score_se^2)),
      # Categorical = mode
      across(where(is.character), get_mode),
      # Continuous = mean
      across(where(is.numeric) & !c(cs_score, cs_score_se),
             ~ round(mean(.x, na.rm=T))),
      # remove grouping post-aggregation
      .groups = "drop") %>%
    mutate(
      log_enroll_0108 = log10(enroll_0108),
      log_enrollment  = log10(total_enrollment))
}
