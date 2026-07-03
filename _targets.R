####################################
# Title: Targets Pipeline Definition
# Author: Dantz Farrow
# Last Modified: 07/02/2026
####################################

# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets); library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tidyverse", "quarto")
)

# Configure backend of tar_make_clustermq() (recommended):
# !!! Does not run on Windows
# options(clustermq.scheduler = "multicore")

# Configure backend of tar_make_future() (optional):
# future::plan(future.callr::callr)

# Run scripts in the R/ folder w/ custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Build Pipeline Dependency Order:
list(

# --- Wrangle
  # NCES Load (R/wrangle/build.R):
  tar_target(nces_file, "data/raw/nces-raw.csv", format  = "file"),
  tar_target(nces_load, load_nces(nces_file))
  # SEDA Load:
  , tar_target(seda_file, "data/raw/seda_admindist_annual_cs_2025.1.csv", format = "file")
  , tar_target(seda_load, load_seda(seda_file))

  # Create & Store Panel (R/wrangle/build.R):
  , tar_target(panel, build_panel(nces_load, seda_load))
  , tar_target(panel_file,
               write_panel(panel, "data/transformed/panel.rds"),
               format = "file")

  # Transform - Cross-Sectional for OLS (R/wrangle/stage.R):
  , tar_target(cross_section, collapse_cs(panel_file))
)

### Console Operations for Inspection & Troubleshooting
# tar_manifest(fields = command)  # pull info on targets
# tar_visnetwork() # plot dependency graph
# tar_make() # run pipeline
# tar_read("object") # pull out objects
# tar_outdated() #
