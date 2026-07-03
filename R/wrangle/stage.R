####################################
# Title: Cross-Sectional Collapse
# Author: Dantz Farrow
# Last Modified: 07/02/2026
####################################

# --- Cross-Section Staging ---

# feature selection
stage_cs <- function(x){
  x %>%
    filter(!is.na(cs_mn_avg_ol)) %>% # transform to inner join
    mutate(enroll_0912 = replace_na(enroll_0912, 0)) %>% # replace na in PK-8
    mutate(total_enrollment = enroll_0108 + enroll_0912) %>% # sum enrollment
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
}

collapse_cs <- function(x){
  x %>%
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
