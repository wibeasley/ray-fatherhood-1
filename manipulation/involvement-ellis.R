# knitr::stitch_rmd(script="./manipulation/te-ellis.R", output="./manipulation/stitched-output/te-ellis.md")
# For a brief description of this file see the presentation at
#   - slides: https://rawgit.com/wibeasley/RAnalysisSkeleton/master/documentation/time-and-effort-synthesis.html#/
#   - code: https://github.com/wibeasley/RAnalysisSkeleton/blob/master/documentation/time-and-effort-synthesis.Rpres
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr, quietly=TRUE)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr")
requireNamespace("tidyr")
requireNamespace("dplyr") #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit") #For asserting conditions meet expected patterns.
requireNamespace("car") #For it's `recode()` function.

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
path_in                        <- "data-unshared/raw/Father Involvement - Raw Data.csv"
path_out                       <- "data-unshared/derived/involvement.csv"
figure_path                    <- 'manipulation/stitched-output/father-involvement/'

# URIs of CSV and County lookup table
path_variable_translator       <- "./data-phi-free/raw/variable-translator.csv"

# ---- load-data ---------------------------------------------------------------
# Read the CSVs
ds                      <- readr::read_csv(path_in, skip=1)
# ds_county               <- readr::read_csv(path_county)

rm(path_in)


# ---- tweak-data --------------------------------------------------------------


# ---- verify-values -----------------------------------------------------------


# ---- specify-columns-to-upload -----------------------------------------------


# ---- save-to-disk ------------------------------------------------------------
readr::write_csv(ds, path_out)


# ---- save-metadata-skeleton --------------------------------------------------
# ds_column <- data.frame(
#   variable          = NA_character_,
#   questionnaire     = NA_character_,
#   retain            = TRUE,
#   reverse_code      = FALSE,
#   reverse_intercept = NA_real_,
#   reverse_slope     = NA_real_,
#   label             = colnames(ds)
# )
# readr::write_csv(ds_column, path_variable_translator)
