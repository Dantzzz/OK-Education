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
options(clustermq.scheduler = "multicore")

# Configure backend of tar_make_future() (optional):
# future::plan(future.callr::callr)

# Run scripts in the R/ folder w/ custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Build Pipeline Dependency Order:
list(

# --- Wrangle Stage
  # NCES Clean:
  tar_target(
    name    = nces_file,
    command = "data/raw/nces-raw.csv",
    format  = "file" # "qs" # Efficient storage for general data objects.
  ),
  tar_target(nces_clean, clean_nces(nces_file))

  # SEDA Clean:
  , tar_target(seda_file, "data/raw/seda_admindist_annual_cs_2025.1.csv", format = "file")
  , tar_target(seda_clean, clean_seda(seda_file))
)

# tar_make() - run pipeline
# tar_read("object") - pulls objects
